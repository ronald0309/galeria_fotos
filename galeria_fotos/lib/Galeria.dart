import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:galeria_fotos/Grid.dart';
import 'package:http/http.dart' as http;
import 'API.dart';

class Galeria extends StatefulWidget {
  @override
  _GaleriaState createState() => _GaleriaState();
}

class _GaleriaState extends State<Galeria> {
  ScrollController _scrollController = ScrollController();
  List<dynamic> _images = [];
  List<dynamic> _filteredImages = [];
  String _searchQuery = '';
  int _currentPage = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadImages();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (!_isLoading &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
      _loadImages();
    }
  }

  Future<void> _loadImages() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final response = await Api.fetchImages(_searchQuery, _currentPage);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final images = data['hits'] as List<dynamic>;

      setState(() {
        _images.addAll(images);
        _filteredImages = _images.toList();
        _currentPage++;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      print('Error al cargar las imagenes');
    }
  }

  void _searchImages(String query) {
    setState(() {
      _searchQuery = query;
      _currentPage = 1;
      _images.clear();
      _filteredImages.clear();
    });

    _loadImages();
  }

  void _filterImages() {
    setState(() {
      _filteredImages = _images.where((image) {
        final tags = image['tags'].toString().toLowerCase();
        return tags.contains(_searchQuery.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Galeria'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
                _filterImages();
              },
              decoration: InputDecoration(
                labelText: 'Buscar',
              ),
            ),
          ),
          Expanded(
            child: OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
                final crossAxisCount =
                    orientation == Orientation.portrait ? 3 : 6;

                return GridView.builder(
                  controller: _scrollController,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                  ),
                  itemCount: _filteredImages.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index < _filteredImages.length) {
                      final image = _filteredImages[index];
                      final sizeFactor = index % 3 == 0 ? 2 : 1;

                      return AnimatedSwitcher(
                        duration: Duration(milliseconds: 500),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: Grid(
                          key: ValueKey(image['id']),
                          image: image,
                          sizeFactor: sizeFactor,
                          onRemove: () {
                            setState(() {
                              _filteredImages.removeAt(index);
                            });
                          },
                        ),
                      );
                    } else if (_isLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

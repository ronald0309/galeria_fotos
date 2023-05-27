import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'API.dart';
import 'Grid.dart';

class Galeria extends StatefulWidget {
  @override
  _GaleriaState createState() => _GaleriaState();
}

class _GaleriaState extends State<Galeria> {
  ScrollController _scrollController = ScrollController();
  List<dynamic> _images = [];
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
        _currentPage++;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      print('Error loading images');
    }
  }

  void _searchImages(String query) {
    setState(() {
      _searchQuery = query;
      _currentPage = 1;
      _images.clear();
    });

    _loadImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Gallery'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _searchImages,
              decoration: InputDecoration(
                labelText: 'Search',
              ),
            ),
          ),
          Expanded(
            child: OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
                final crossAxisCount =
                    orientation == Orientation.portrait ? 3 : 6;

                return ImageGrid(
                  scrollController: _scrollController,
                  images: _images,
                  isLoading: _isLoading,
                  crossAxisCount: crossAxisCount,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

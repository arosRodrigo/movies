import 'package:flutter/material.dart';

class MoviePage extends StatelessWidget {

  final Map _movieData;

  MoviePage(this._movieData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_movieData['Title']),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(_movieData['Poster']),
      ),
    );
  }
}
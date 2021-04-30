import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:movies/movie_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  
  String _search;
  int _page;

  Future<Map> _getMovies() async {
    http.Response response;

    if (_search == null)
      response = await http
          .get('http://www.omdbapi.com/?s=terminator&apikey=694b31e1');
    else
      response = await http.get(
          'http://www.omdbapi.com/?s=$_search&page=$_page&apikey=694b31e1');

    return convert.jsonDecode(response.body);
  }

  void _getMoviest() async {
  //await Firestore.instance.collection("users").document().setData({'name':'anderson'}); //incluir dado
  await Firestore.instance.collection("users").snapshots().forEach((element) {//consulta dado
    element.documents.forEach((doc) { 
      print(doc.documentID);
    });
  });
}

  @override
  void initState() {
    super.initState();
    _getMoviest();
    _getMovies().then((map) {
      //print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Movies Friends"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: "Pesquise aqui",
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
            ),
            style: TextStyle(color: Colors.white, fontSize: 18.0),
            textAlign: TextAlign.center,
            onSubmitted: (text) {
              setState(() {
                _search = text;
              });
            },
          ),
        ),
        Expanded(
            child: FutureBuilder(
                future: _getMovies(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200.0,
                        height: 200.0,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5.0,
                        ),
                      );
                    default:
                      if (snapshot.hasError ||
                          snapshot.data.containsKey('Search') == false)
                        return Container(
                          child: Text(
                            'filmes não encontrados',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      else {
                        //print(snapshot.data['totalResults']);
                        return _createMovieTable(context, snapshot);
                      }
                  }
                })),
      ]),
    );
  }

  Widget _createMovieTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: snapshot.data['Search'].length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Image.network(
              snapshot.data['Search'][index]['Poster'],
              height: 300.0,
              fit: BoxFit.cover,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MoviePage(snapshot.data['Search'][index])));
            },
          );
        });
  }
}

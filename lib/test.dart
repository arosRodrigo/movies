import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  _getMovies();
}

void _getMovies() async {
  //await Firestore.instance.collection("users").document('1BUPfkRKoTOGKKAT5nVc');
  await Firestore.instance.collection("clients").snapshots().forEach((element) {
    element.documents.forEach((doc) { 
      print(doc.documentID);
    });
  });
}
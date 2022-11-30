// ignore_for_file: avoid_function_literals_in_foreach_calls, dead_code, non_constant_identifier_names

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Beer.dart';
import 'package:http/http.dart' as http;

import 'beerCard.dart';
import 'five_best_beers_screen.dart';
import 'five_worst_beers_screen.dart';

class BeerListScreen extends StatefulWidget {
  const BeerListScreen({Key? key}) : super(key: key);

  @override
  State<BeerListScreen> createState() => _BeerListScreenState();
}

class _BeerListScreenState extends State<BeerListScreen> {
  List<Beer> beers = [];
  Future<List<Beer>> getAllBeers() async {
    final response = await http
        .get(Uri.parse('https://api.punkapi.com/v2/beers')); //?per_page=150
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      for (var jsonBeer in jsonData) {
        Beer beer = Beer(
          id: jsonBeer['id'],
          name: jsonBeer['name'],
          imageUrl: jsonBeer['image_url'],
          abv: jsonBeer['abv'],
          tagline: jsonBeer['tagline'],
          description: jsonBeer['description'],
          ibu: jsonBeer['ibu'],
          ingredients: jsonBeer['ingredients'],
          rating: 0,
        );
        beers.add(beer);
      }
      //saveBeers(beers);
      return beers;
    } else {
      return <Beer>[];
    }
  }

  void saveBeers(List<Beer> beers) {
    for (Beer beer in beers) {
      FirebaseFirestore.instance.collection('beers').add({
        'id': beer.id,
        'name': beer.name,
        'imageUrl': beer.imageUrl,
        'abv': beer.abv,
        'tagline': beer.tagline,
        'description': beer.description,
        'ibu': beer.ibu,
        'ingredients': beer.ingredients,
        'rating': beer.rating,
      });
    }
  }

  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> documents = [];
  String searchText = "";
  List<String> beerTypes = [
    "IPA",
    "APA",
    "Pale ale",
    "Brown",
    "Scotch ale",
    "Pilsner",
    "Belgian ale"
  ];

  @override
  Widget build(BuildContext context) {
    CollectionReference reference =
        FirebaseFirestore.instance.collection('beers');
    return Scaffold(
        appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('List of beers'),
                Image.asset('beer2.png', width: 30, height: 30),
              ],
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            )),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 100, right: 100, top: 5, bottom: 10),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  hintText: 'Search...',
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: SizedBox(
                      height: 50,
                      width: 250,
                      child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(255, 180, 0, 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return FiveBestBeersScreen(reference);
                            }));
                          },
                          child: const Center(
                              child: Text("See 5 best beers",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)))),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: SizedBox(
                      height: 50,
                      width: 250,
                      child: TextButton(
                          style: TextButton.styleFrom(
                              side: const BorderSide(
                                  width: 2.0, color: Colors.black),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return FiveWorstBeersScreen(reference);
                            }));
                          },
                          child: const Center(
                              child: Text("See 5 worst beers",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)))),
                    ),
                  ),
                ),
              ],
            ),
            Flexible(
              child: StreamBuilder(
                stream: reference.snapshots(),
                builder: (_, snapshot) {
                  if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  if (snapshot.hasData) {
                    documents = snapshot.data!.docs;
                    if (searchText.isNotEmpty) {
                      documents = documents.where((element) {
                        return element
                            .get('name')
                            .toString()
                            .toLowerCase()
                            .contains(searchText.toLowerCase());
                      }).toList();
                    }
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: documents.length,
                          itemBuilder: (context, index) {
                            var docId = snapshot.data!.docs[index].reference.id;
                            Beer beer = Beer(
                              abv: documents[index]['abv'],
                              description: documents[index]['description'],
                              ibu: documents[index]['ibu'],
                              id: documents[index]['id'],
                              imageUrl: documents[index]['imageUrl'],
                              ingredients: documents[index]['ingredients'],
                              name: documents[index]['name'],
                              rating: documents[index]['rating'],
                              tagline: documents[index]['tagline'],
                            );
                            return BeerCard(beer, docId);
                          }),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ));
  }
}

// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/Beer.dart';

import 'beerCard.dart';
import 'five_worst_beers_screen.dart';

class FiveBestBeersScreen extends StatelessWidget {
  FiveBestBeersScreen(this.reference, {super.key});
  CollectionReference<Object?> reference;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Best 5 beers'),
                Image.asset('beer2.png', width: 30, height: 30)
              ],
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            )),
        body: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  height: 50,
                  width: 250,
                  child: TextButton(
                      style: TextButton.styleFrom(
                          side:
                              const BorderSide(width: 2.0, color: Colors.black),
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
            StreamBuilder(
              stream: reference
                  .orderBy('rating', descending: true)
                  .limit(5)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                if (snapshot.hasData) {
                  return Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var args = snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;
                            var docId = snapshot.data!.docs[index].reference.id;
                            Beer beer = Beer(
                              abv: args['abv'],
                              description: args['description'],
                              ibu: args['ibu'],
                              id: args['id'],
                              imageUrl: args['imageUrl'],
                              ingredients: args['ingredients'],
                              name: args['name'],
                              rating: args['rating'],
                              tagline: args['tagline'],
                            );
                            return BeerCard(beer, docId);
                          }));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ));
  }
}

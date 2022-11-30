// ignore_for_file: must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Beer.dart';
import 'ingredient.dart';

class BeerDetailScreen extends StatefulWidget {
  late final Beer beer;
  String docId;
  BeerDetailScreen({Key? key, required this.beer, required this.docId})
      : super(key: key);
  @override
  State<BeerDetailScreen> createState() => _BeerDetailScreenState();
}

class _BeerDetailScreenState extends State<BeerDetailScreen> {
  @override
  Widget build(BuildContext context) {
    String beerIng() {
      String ret = "";
      Ingredient ingredient = Ingredient(
          malt: widget.beer.ingredients['malt'],
          hops: widget.beer.ingredients['hops'],
          yeast: widget.beer.ingredients['yeast']);
      for (Map<String, dynamic> malt in ingredient.malt) {
        ret +=
            "${malt['name']}(${malt['amount']['value']}${malt['amount']['unit']}), ";
      }
      for (Map<String, dynamic> hop in ingredient.hops) {
        ret +=
            "${hop['name']}(${hop['amount']['value']}${hop['amount']['unit']}), ";
      }
      ret += ingredient.yeast;
      String ret2 = ret.replaceAll("kilograms", "kg");
      String ret3 = ret2.replaceAll("grams", "g");
      return ret3;
    }

    void updateRating(int num) async {
      FirebaseFirestore.instance
          .collection('beers')
          .doc(widget.docId)
          .update({'rating': FieldValue.increment(num)});
    }

    var beerRef = FirebaseFirestore.instance
        .collection('beers')
        .doc(widget.docId)
        .snapshots();
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: beerRef,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          if (snapshot.hasData) {
            var data = snapshot.data!.data();
            Beer beer2 = Beer(
              abv: data!['abv'],
              description: data['description'],
              ibu: data['ibu'],
              id: data['id'],
              imageUrl: data['imageUrl'],
              ingredients: data['ingredients'],
              name: data['name'],
              rating: data['rating'],
              tagline: data['tagline'],
            );
            return Scaffold(
                body: Stack(
              children: [
                Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: PreferredSize(
                      preferredSize: const Size.fromHeight(200.0),
                      child: AppBar(
                          leading: IconButton(
                            icon: const Icon(Icons.arrow_back_ios,
                                color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          backgroundColor: const Color.fromRGBO(255, 180, 0, 1),
                          elevation: 0,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(30),
                            ),
                          )),
                    )),
                Column(
                  children: [
                    const SizedBox(
                      height: 50.0,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0),
                        child: Text(
                          beer2.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 200.0,
                      child: Image.network(widget.beer.imageUrl),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 50.0),
                            child: Text(beer2.tagline,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold)))),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 50.0),
                            child: Text(beer2.description,
                                textAlign: TextAlign.left,
                                style: const TextStyle(fontSize: 16)))),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(children: const [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                              padding: EdgeInsets.only(left: 50.0),
                              child: SizedBox(
                                  width: 90.0,
                                  child: Text(
                                    'abv',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )))),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: SizedBox(
                                  width: 90.0,
                                  child: Text(
                                    'ibu',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )))),
                    ]),
                    Row(children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                              padding: const EdgeInsets.only(left: 50.0),
                              child: SizedBox(
                                  width: 90.0,
                                  child: Text(
                                    "${beer2.abv}%",
                                    style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(255, 180, 0, 1)),
                                  )))),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: SizedBox(
                                  width: 90.0,
                                  child: Text(
                                    "${beer2.ibu}%",
                                    style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(255, 180, 0, 1)),
                                  )))),
                    ]),
                    const SizedBox(
                      height: 10,
                    ),
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 50.0),
                          child: Text(
                            'Ingredients:',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        )),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                            padding: const EdgeInsets.only(left: 50.0),
                            child: Text(beerIng()))),
                    const SizedBox(
                      height: 100,
                    ),
                    Row(
                      children: [
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 50.0),
                              child: Text(
                                'Rate this beer',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            )),
                        const SizedBox(
                          width: 100,
                        ),
                        TextButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.black),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0)))),
                            onPressed: () {
                              updateRating(-1);
                            },
                            child: const Center(
                                child: Icon(
                              Icons.arrow_downward,
                              color: Color.fromRGBO(255, 180, 0, 1),
                            ))),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Text(beer2.rating.toString(),
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold)))),
                        TextButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.black),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0)))),
                            onPressed: () {
                              updateRating(1);
                            },
                            child: const Center(
                                child: Icon(
                              Icons.arrow_upward,
                              color: Color.fromRGBO(255, 180, 0, 1),
                            ))),
                      ],
                    )
                  ],
                ),
              ],
            ));
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}

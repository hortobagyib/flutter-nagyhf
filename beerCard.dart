// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'Beer.dart';
import 'beer_details_page.dart';

// ignore: must_be_immutable
class BeerCard extends StatelessWidget {
  BeerCard(this.beer, this.docId, {super.key});
  late Beer beer;
  String docId;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Column(
      children: [
        Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Table(
                border: TableBorder.all(color: Colors.white),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: <TableRow>[
                  TableRow(
                    children: [
                      Center(
                        child: Container(
                            decoration: const BoxDecoration(
                                color: Color.fromRGBO(255, 180, 0, 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            width: 150,
                            height: 150,
                            child: Center(
                                child: Image.network(beer.imageUrl,
                                    width: 120, height: 120))),
                      ),
                      Center(
                          child: Table(
                              border: TableBorder.all(color: Colors.white),
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              children: <TableRow>[
                            TableRow(children: [
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(beer.name,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)))
                            ]),
                            TableRow(children: [
                              Text(
                                beer.tagline,
                                style: const TextStyle(fontSize: 16),
                              )
                            ]),
                            TableRow(children: [
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text("${beer.abv}%",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          color:
                                              Color.fromRGBO(255, 180, 0, 1))))
                            ]),
                            TableRow(children: [
                              SizedBox(
                                height: 50,
                                width: 100,
                                child: TextButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.black),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.0)))),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                        return BeerDetailScreen(
                                            beer: beer, docId: docId);
                                      }));
                                    },
                                    child: const Center(
                                        child: Text("More info",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white)))),
                              )
                            ])
                          ]))
                    ],
                  )
                ]))
      ],
    ));
  }
}

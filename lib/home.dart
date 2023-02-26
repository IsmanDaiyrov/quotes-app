import 'package:flutter/material.dart';
import 'package:quotesapp/quotespage.dart';
import 'package:quotesapp/utils.dart';

import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ---------------------------------------------------------------------------
  // create a reference to all categories to use in the for loop
  List<String> categories = ["love", "inspirational", "life", "humor"];

  List quotes = [];
  List authors = [];

  bool isDataThere = false;

  // GET response from website
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getquotes();
  }

  // parse the data
  getquotes() async {
    String url = "https://quotes.toscrape.com/";
    Uri uri = Uri.parse(url);
    http.Response response = await http.get(uri);
    dom.Document document = parser.parse(response.body);
    final quotesclass = document.getElementsByClassName("quote");

    quotes = quotesclass
        .map((element) => element.getElementsByClassName('text')[0].innerHtml)
        .toList();
    authors = quotesclass
        .map((element) => element.getElementsByClassName('author')[0].innerHtml)
        .toList();

    setState(() {
      isDataThere = true;
    });
  }

  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // -----------------------------------------------------------------------
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 30, bottom: 30),
              child: Text("Quotes App",
                  style: textStyle(30, Colors.black, FontWeight.w700)),
            ),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: categories.map((category) {
                return InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QuotesPage(category))),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(40)),
                    child: Center(
                      child: Text(
                        category.toUpperCase(),
                        style: textStyle(20, Colors.white, FontWeight.bold),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(
              height: 20,
            ),
            // --------------- Section for the home quotes ---------------
            isDataThere == false
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: quotes.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        child: Card(
                          elevation: 10,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20, left: 20, bottom: 20),
                                child: Text(
                                  quotes[index],
                                  style: textStyle(
                                      18, Colors.black, FontWeight.w700),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  authors[index],
                                  style: textStyle(
                                      15, Colors.black, FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
      // -----------------------------------------------------------------------
    );
  }
}

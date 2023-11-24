import 'package:flutter/material.dart';
import 'package:newsapp/tabs/favourite.dart';
import 'package:newsapp/tabs/home.dart';
import 'package:newsapp/tabs/topheadlines.dart';

class Actual extends StatefulWidget {
  const Actual({super.key});

  @override
  State<Actual> createState() => _ActualState();
}

class _ActualState extends State<Actual> {
  int _index = 0;
  List<Widget> tabs = const [
    HomePage(),
    TopHeadlines(),
    Favourite(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News App"),
      ),
      body: Center(
        child: tabs[_index],
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              label: "Home",
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: "Top News",
              icon: Icon(Icons.auto_graph_rounded),
            ),
            BottomNavigationBarItem(
              label: "Favourite",
              icon: Icon(Icons.favorite),
            ),
          ],
          currentIndex: _index,
          onTap: (value) {
            setState(() {
              _index = value;
            });
          }),
    );
  }
}

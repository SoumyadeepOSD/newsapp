import 'package:flutter/material.dart';
import 'package:newsapp/constant/color.dart';
import 'package:newsapp/provider/stateprovider.dart';
import 'package:newsapp/pages/webview.dart';
import 'package:provider/provider.dart';

class Favourite extends StatefulWidget {
  const Favourite({super.key});

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height - 100,
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height - 100,
                width: double.infinity,
                child: ListView.builder(
                  itemCount: provider.items.length,
                  itemBuilder: (context, index) {
                    print(provider.items[index]['title']);
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      color: white,
                      width: double.infinity,
                      child: Column(
                        children: [
                          const SizedBox(height: 10.0),
                          SizedBox(
                            height: MediaQuery.of(context).size.height - 170,
                            child: ListView.builder(
                              itemCount: provider.items.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  color: Colors.grey.shade100,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image(
                                          fit: BoxFit.fill,
                                          height: 100,
                                          width: 100,
                                          image: NetworkImage(
                                            provider.items[index]['imageurl']!,
                                          ),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 180,
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 130,
                                                  child: Text(
                                                    provider.items[index]
                                                        ['title']!,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              WebViewPage(
                                                            url: provider
                                                                .items[index]
                                                                    ['url']
                                                                .toString(),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    icon: const Icon(
                                                        Icons.arrow_outward))
                                              ],
                                            ),
                                          ),
                                          Text(
                                            provider.items[index]['date']!,
                                            style: TextStyle(
                                              color: red,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

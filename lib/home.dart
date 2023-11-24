import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/constant/color.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:newsapp/stateprovider.dart';
import 'package:newsapp/webview.dart';
import 'package:provider/provider.dart';

TextEditingController _controller = TextEditingController();
final apiKey = dotenv.env['API_KEY'];
DateTime? _selectedfromValue;
DateTime? _selectedtoValue;
String? _selectedsortbyValue;
List<String> sortby = ['relevancy', 'popularity', 'publishedAt'];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Map<String, dynamic>> fetchAPI() async {
    String query = _controller.text.toString();
    try {
      final baseUrl =
          "https://newsapi.org/v2/everything?q=$query&from=${_selectedfromValue.toString().split(' ')[0]}&to=${_selectedtoValue.toString().split(' ')[0]}&sortBy=$_selectedsortbyValue&apiKey=$apiKey";
      setState(() {});
      var response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  void _showfromdatepicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    ).then((value) => {
          setState(() {
            _selectedfromValue = value;
          })
        });
  }

  void _showtodatepicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    ).then((value) => {
          setState(() {
            _selectedtoValue = value;
          }),
          print(_selectedtoValue.toString().split(' ')[0])
        });
  }

  @override
  Widget build(BuildContext context) {
    final providers = Provider.of<MyProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: "Search Topics",
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: blue,
                            padding: const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 20.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        onPressed: () {
                          fetchAPI();
                        },
                        child: Text(
                          "Search",
                          style: TextStyle(color: white),
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () => _showfromdatepicker(),
                      child: const Chip(
                        label: Text("From"),
                        avatar: Icon(Icons.calendar_month),
                      ),
                    ),
                    InkWell(
                      onTap: () => _showtodatepicker(),
                      child: const Chip(
                        label: Text("To"),
                        avatar: Icon(Icons.calendar_month),
                      ),
                    ),
                    DropdownButton<String>(
                      hint: const Center(child: Text("Sort By")),
                      value: _selectedsortbyValue,
                      onChanged: (value) {
                        setState(() {
                          _selectedsortbyValue = value;
                        });
                      },
                      items:
                          sortby.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                Expanded(
                  child: FutureBuilder<Map<String, dynamic>>(
                    future: fetchAPI(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasData) {
                        Map<String, dynamic> data = snapshot.data!;
                        List<dynamic> newsdata = data['articles'];

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
                                height:
                                    MediaQuery.of(context).size.height - 170,
                                child: ListView.builder(
                                  itemCount: data['articles'].length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      color: Colors.grey.shade100,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image(
                                              fit: BoxFit.fill,
                                              height: 100,
                                              width: 100,
                                              image: NetworkImage(
                                                newsdata[index]['urlToImage'],
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
                                                        newsdata[index]
                                                            ['title'],
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
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
                                                              builder:
                                                                  (context) =>
                                                                      WebViewPage(
                                                                url: newsdata[
                                                                        index]
                                                                    ['url'],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        icon: const Icon(Icons
                                                            .arrow_outward))
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    newsdata[index]
                                                        ['publishedAt'],
                                                    style: TextStyle(
                                                      color: red,
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      print(newsdata[index]
                                                          ['title']);
                                                      print(
                                                        providers.isFavourite(
                                                          title: newsdata[index]
                                                              ['title'],
                                                        ),
                                                      );
                                                      providers.toggleFavorite(
                                                        title: newsdata[index]
                                                            ['title'],
                                                        imageurl:
                                                            newsdata[index]
                                                                ['urlToImage'],
                                                        date: newsdata[index]
                                                            ['publishedAt'],
                                                        url: newsdata[index]
                                                            ['url'],
                                                      );
                                                    },
                                                    icon: Icon(providers
                                                            .isFavourite(
                                                      title: newsdata[index]
                                                          ['title'],
                                                    )
                                                        ? Icons.favorite
                                                        : Icons
                                                            .favorite_border),
                                                  )
                                                ],
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
                      } else {
                        return const Center(
                          child: Text("🔍Search for something..."),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

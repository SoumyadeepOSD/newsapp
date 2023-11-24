import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:newsapp/provider/stateprovider.dart';
import 'package:newsapp/pages/webview.dart';
import 'package:provider/provider.dart';
import '../constant/color.dart';
import 'dart:convert';

TextEditingController _controller = TextEditingController();
final apiKey = dotenv.env['API_KEY'];
List<String> categories = [
  'business',
  'entertainment',
  'general',
  'health',
  'science',
  'sports',
  'technology'
];
List<String> countries = [
  'ae',
  'ar',
  'at',
  'au',
  'be',
  'bg',
  'br',
  'ca',
  'ch',
  'cn',
  'co',
  'cu',
  'cz',
  'de',
  'eg',
  'fr',
  'gb',
  'gr',
  'hk',
  'hu',
  'id',
  'ie',
  'il',
  'in',
  'it',
  'jp',
  'kr',
  'lt',
  'lv',
  'ma',
  'mx',
  'my',
  'ng',
  'nl',
  'no',
  'nz',
  'ph',
  'pl',
  'pt',
  'ro',
  'rs',
  'ru',
  'sa',
  'se',
  'sg',
  'si',
  'sk',
  'th',
  'tr',
  'tw',
  'ua',
  'us',
  've',
  'za'
];
String? _categoryValue;
String? _country;

class TopHeadlines extends StatefulWidget {
  const TopHeadlines({super.key});

  @override
  State<TopHeadlines> createState() => _TopHeadlinesState();
}

class _TopHeadlinesState extends State<TopHeadlines> {
  Future<Map<String, dynamic>> _fetchAPI() async {
    String _topic = _controller.text.toString();
    try {
      final baseUrl =
          "https://newsapi.org/v2/top-headlines?country=$_country&q=$_topic&category=$_categoryValue&apiKey=$apiKey";
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
                          _fetchAPI();
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
                    DropdownButton<String>(
                      hint: const Center(child: Text("Countries")),
                      value: _country,
                      onChanged: (value) {
                        setState(() {
                          _country = value;
                        });
                      },
                      items: countries
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    DropdownButton<String>(
                      hint: const Center(child: Text("Categories")),
                      value: _categoryValue,
                      onChanged: (value) {
                        setState(() {
                          _categoryValue = value;
                        });
                      },
                      items: categories
                          .map<DropdownMenuItem<String>>((String value) {
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
                    future: _fetchAPI(),
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
                                                newsdata[index]['urlToImage'] ??
                                                    'https://th.bing.com/th/id/OIP.y6BTFILhAS31TXksixl6pwHaE8?rs=1&pid=ImgDetMain',
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
                                                                ['title'] ??
                                                            'No Title',
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
                                                                        [
                                                                        'url'] ??
                                                                    'No URL',
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
                                                            ['publishedAt'] ??
                                                        'Published At',
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
                                                          ['title']!);
                                                      print(
                                                        providers.isFavourite(
                                                          title: newsdata[index]
                                                              ['title']!,
                                                        ),
                                                      );
                                                      providers.toggleFavorite(
                                                        title: newsdata[index]
                                                            ['title']!,
                                                        imageurl:
                                                            newsdata[index]
                                                                ['urlToImage']!,
                                                        date: newsdata[index]
                                                            ['publishedAt']!,
                                                        url: newsdata[index]
                                                            ['url']!,
                                                      );
                                                    },
                                                    icon: Icon(providers
                                                            .isFavourite(
                                                      title: newsdata[index]
                                                          ['title']!,
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

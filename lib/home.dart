import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/constant/color.dart';

final baseUrl =
    "https://newsapi.org/v2/everything?q=$query&apiKey=4dc863fee7f74a98b2c9cb5931311f06";
String query = "";
TextEditingController _controller = TextEditingController();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Map<String, dynamic>> fetchAPI() async {
    try {
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

  String transformToReadableTime(String dateTimeString) {
    DateTime parsedTime = DateTime.parse(dateTimeString);
    String month = parsedTime.month.toString();
    month == '1'
        ? month = 'Jan'
        : month == '2'
            ? month = 'Feb'
            : month == '3'
                ? month == 'Mar'
                : month == '4'
                    ? 'Apr'
                    : month == '5'
                        ? 'May'
                        : month == '6'
                            ? 'Jun'
                            : month == '7'
                                ? 'Jul'
                                : month == '8'
                                    ? 'Aug'
                                    : month == '9'
                                        ? 'Sep'
                                        : month == '10'
                                            ? 'Oct'
                                            : month == '11'
                                                ? 'Nov'
                                                : month == 'Dec';
    String formattedTime = '${parsedTime.day}-$month-${parsedTime.year} '
        '${parsedTime.hour.toString().padLeft(2, '0')}:${parsedTime.minute.toString().padLeft(2, '0')}';

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
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
                  color: lightgrey,
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
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text("Search"),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        height: MediaQuery.of(context).size.height - 130,
                        child: ListView.builder(
                          itemCount: newsdata.length,
                          itemBuilder: (context, index) {
                            return Container(
                              color: Colors.grey.shade100,
                              margin: const EdgeInsets.symmetric(vertical: 10),
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
                                        child: Text(
                                          newsdata[index]['title'],
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        transformToReadableTime(
                                          newsdata[index]['publishedAt'],
                                        ),
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
              } else {
                print(snapshot.error);
                return const Center(
                  child: Text("Something went wrong"),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

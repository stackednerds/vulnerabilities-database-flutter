import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'news_details_activity.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<dynamic> articles = [];
  List<dynamic> filteredArticles = [];
  bool isSearching = false;
  bool hasInternet = true;
  late StreamSubscription<ConnectivityResult> connectivitySubscription;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    fetchNewsData();
    subscribeToConnectivityChanges();
  }

  @override
  void dispose() {
    connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      hasInternet = connectivityResult != ConnectivityResult.none;
    });
  }

  Future<void> fetchNewsData() async {
    if (!hasInternet) {
      return;
    }

    try {
      final dio = Dio();
      final response = await dio.get(
        'https://newsapi.org/v2/everything?q=cybersecurity&apiKey=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
      );

      if (response.statusCode == 200) {
        final jsonData = response.data;
        setState(() {
          articles = jsonData['articles'];
          filteredArticles = articles; // Initialize filteredArticles with all articles
        });
      } else {
        // Handle error
        // print('Failed to fetch news data.');
      }
    } catch (error) {
      // Handle error
      // print('Failed to fetch news data: $error');
    }
  }

  void filterArticles(String query) {
    setState(() {
      filteredArticles = articles.where((article) {
        final title = article['title'].toString().toLowerCase();
        final description = article['description'].toString().toLowerCase();
        return title.contains(query) || description.contains(query);
      }).toList();
    });
  }

  void subscribeToConnectivityChanges() {
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        hasInternet = result != ConnectivityResult.none;
        if (hasInternet) {
          fetchNewsData();
        }
      });
    });
  }

  Widget buildBody() {
    if (!hasInternet) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.signal_wifi_connected_no_internet_4, color: Colors.white38, size: 170.0,),
            Text(
              'No internet connection',
              style: TextStyle(color: Colors.white38, fontSize: 30.0,),
            ),
          ],
        ),
      );
    } else {
      return ListView.builder(
        itemCount: filteredArticles.length,
        itemBuilder: (context, index) {
          final article = filteredArticles[index];

          return GFListTile(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            listItemTextColor: Colors.white,
            color: const Color(0xFF222222),
            titleText: article['title'],
            subTitle: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Published at: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(article['publishedAt']))}",
                style: const TextStyle(color: Colors.white),
              ),
            ),
            description: Text(
              article['description'],
              style: const TextStyle(color: Colors.white70),
            ),
            icon: const Icon(Icons.read_more, color: Colors.white70),
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) =>
                      NewsDetailPage(article: article),
                  transitionsBuilder: (_, animation, __, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                ),
              );
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.short_text),
        ),
        toolbarHeight: 60.0,
        backgroundColor: const Color(0xFF121212),
        title: isSearching
            ? TextField(
          onChanged: filterArticles,
          decoration: const InputDecoration(
            hintText: 'Search',
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
        )
            : const Text("Cybersecurity News"),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.filter_alt),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  filteredArticles = articles;
                }
              });
            },
          ),
        ],
      ),
      body: buildBody(),
    );
  }
}

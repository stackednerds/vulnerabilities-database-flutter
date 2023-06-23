import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';


class NewsDetailPage extends StatelessWidget {
  final Map<String, dynamic> article;

  const NewsDetailPage({super.key, required this.article});

  Future<dynamic> _openLink() async {
    final uri = Uri.parse(article['url']);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw "Could not launch ${article['url']}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: article['url']));  // copied successfully
                const snackBar = SnackBar(
                  content: Text('Article link copied to clipboard'),
                  duration: Duration(seconds: 2),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              icon: const Icon(Icons.link, color: Colors.white,))
        ],
        toolbarHeight: 60.0,
        backgroundColor: const Color(0xFF121212),
        title: const Text('News Detail'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            article['urlToImage'] != null
                ? Image.network(article['urlToImage'],)
                : const SizedBox.shrink(),
            const SizedBox(height: 16.0),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Author: ${article['author'] ?? "Unknown"}",
                          style: const TextStyle(color: Colors.white),),
                        Text("Published date: ${DateFormat('yyyy-MM-dd').format(
                            DateTime.parse(article['publishedAt']))}",
                          style: const TextStyle(color: Colors.white),),
                      ],
                    ),
                    IconButton(onPressed: _openLink, icon: const Icon(Icons.language, color: Colors.white70, size: 30.0,))
                  ],
                )
            ),
            const SizedBox(height: 24.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                article['title'],
                style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                article['description'],
                style: const TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16.0),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Content:',
                style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                article['content'],
                style: const TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Full article link:',
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: GestureDetector(
                onTap: _openLink,
                child: Text(
                  article['url'],
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}

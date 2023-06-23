import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';

class SearchActivity extends StatefulWidget {
  const SearchActivity({Key? key}) : super(key: key);

  @override
  _SearchActivityState createState() => _SearchActivityState();
}

class _SearchActivityState extends State<SearchActivity> {
  
  List<dynamic> exploits = [];
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSearching = false;
  bool isSearchingInProgress = false;
  String searchWord = "";
  bool triggerSearchResults = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchExploits(String searchTerm) async {
    setState(() {
      exploits.clear();
      isSearchingInProgress = true;
      triggerSearchResults = true;
    });

    try {
      var response = await Dio().get(
          'https://exploits.shodan.io/api/search?query=$searchTerm&key=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
      setState(() {
        exploits = response.data['matches'] as List<dynamic>;
        isSearchingInProgress = false;
        searchWord = searchTerm;
      });
    } catch (error) {
      // Handle error
      // print('Failed to fetch news data: $error');
      setState(() {
        isSearchingInProgress = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () { },
          icon: const Icon(
            Icons.short_text,
          ),
        ),
        toolbarHeight: 60.0,
        backgroundColor: const Color(0xFF121212),
        title: isSearching
            ? TextField(
                onSubmitted: (value) {
                  _searchExploits(value);
                },
                decoration: const InputDecoration(
                  hintText: 'Search for exploits...',
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                style: const TextStyle(color: Colors.white),
              )
            : const Text("Search Exploits"),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  _searchExploits(_searchController.text);
                }
              });
            },
          ),
        ],
      ),
      body: isSearchingInProgress
          ? const Center(child: SizedBox(
          width: 50.0,
          height: 50.0,
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ))
          : exploits.isEmpty
          ? Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            triggerSearchResults ? Text('No results found for "$searchWord"', style: const TextStyle(color: Colors.white, fontSize: 17.0),)
                : const Text('No results found', style: TextStyle(color: Colors.white, fontSize: 17.0),),
            const Icon(
              Icons.search_off,
              color: Colors.white,
              size: 40.0,
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: exploits.length,
        itemBuilder: (BuildContext context, int index) {
          var exploit = exploits[index];

          return GFListTile(
            margin: const EdgeInsets.symmetric(
                vertical: 8.0, horizontal: 8.0),
            listItemTextColor: Colors.white,
            color: const Color(0xFF222222),
            titleText: "${exploit['source']}-${exploit['_id']}",
            description: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                exploit['description'],
                style: const TextStyle(color: Colors.white70),
              ),
            ),
            icon:
            const Icon(Icons.open_in_new, color: Colors.white70),
          );
        },
      )
    );
  }
  
}

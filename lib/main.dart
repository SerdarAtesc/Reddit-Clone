import 'package:flutter/material.dart';
import 'Models/Post_Model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<PostModel> futurePosts;

  Future<List<PostModel>> fetchPosts() async {
    final response = await http.get(
        Uri.parse('https://www.reddit.com/r/flutterdev/top.json?count=20'),
        headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      final jsonparsed = json.decode(response.body)["data"]["children"];
      Iterable listt = json.decode(response.body)["data"]["children"];
      List<PostModel> products =
          listt.map((i) => PostModel.listfromJson(i)).toList();

      return products;
    } else {
      throw Exception('Failed to load album');
    }
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Reddit"),
          centerTitle: true,
        ),
        body: Container(
          child: FutureBuilder<List<PostModel>>(
            future: fetchPosts(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    PostModel Posts = snapshot.data![index];
                    return postLine(Posts);
                  },
                );
              } else if (snapshot.hasError) {
                return Center(child: CircularProgressIndicator());
              }

              // By default, show a loading spinner.
              return Center(child: const CircularProgressIndicator());
            },
          ),
        ));
  }

  postLine(PostModel posts) {
    return GestureDetector(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Color(0x99999),
          backgroundImage: NetworkImage(posts.thumbnail),
        ),
        title: RichText(
          text: TextSpan(
              text: posts.author + "\n",
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                    text: posts.title,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ))
              ]),
        ),
      ),
    );
  }
}

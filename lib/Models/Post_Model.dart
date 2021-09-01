class PostModel {
  final String title;
  //final String description;
  final String author;
  final String thumbnail;

  PostModel({
    required this.author,
    required this.title,
    //required this.description,
    required this.thumbnail,
  });

  factory PostModel.listfromJson(Map<String, dynamic> json) {
    return PostModel(
      author: json['data']['author'],
      //description: json['data']["all_awardings"]['description'],
      title: json['data']['title'],
      thumbnail: json['data']['thumbnail'],
    );
  }
}

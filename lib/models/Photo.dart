class Photo {
  final String url;
  final String user;
  final String desc;

  Photo({
    this.url,
    this.user,
    this.desc,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      url: json['urls']['regular'],
      user: json['user']['username'],
      desc: json['alt_description'],
    );
  }
}

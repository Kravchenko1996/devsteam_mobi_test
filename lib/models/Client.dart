class Client {
  int id;
  final String name;
  final String email;
  static final columns = ["id", "name", "email"];

  Client({
    this.id,
    this.name,
    this.email,
  });

  factory Client.fromMap(Map<String, dynamic> json) => Client(
        id: json['id'],
        name: json['name'],
        email: json['email'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
      };
}
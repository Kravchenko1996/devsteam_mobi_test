class Client {
  int id;
  String name;
  String email;
  int phone;
  int mobile;
  String address1;
  String address2;
  String city;
  String state;
  int postal;
  String country;
  String notes;

  Client({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.mobile,
    this.address1,
    this.address2,
    this.city,
    this.state,
    this.postal,
    this.country,
    this.notes,
  });

  factory Client.fromMap(Map<String, dynamic> json) => Client(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        mobile: json['mobile'],
        address1: json['address1'],
        address2: json['address2'],
        city: json['city'],
        state: json['state'],
        postal: json['postal'],
        country: json['country'],
        notes: json['notes'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'mobile': mobile,
        'address1': address1,
        'address2': address2,
        'city': city,
        'state': state,
        'postal': postal,
        'country': country,
        'notes': notes,
      };
}

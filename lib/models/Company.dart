class Company {
  int id;
  String logo;
  String name;
  int phone;
  int mobile;
  String address;
  String email;
  String website;

  Company({
    this.id,
    this.logo,
    this.name,
    this.phone,
    this.mobile,
    this.address,
    this.email,
    this.website,
  });

  factory Company.fromMap(Map<String, dynamic> json) => Company(
        id: json['id'],
        logo: json['logo'],
        name: json['name'],
        phone: json['phone'],
        mobile: json['mobile'],
        address: json['address'],
        email: json['email'],
        website: json['website'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'logo': logo,
        'name': name,
        'phone': phone,
        'mobile': mobile,
        'address': address,
        'email': email,
        'website': website,
      };
}

class UserModel {
  String? email;
  String? uid;
  String? token;
  String? name;
  String? address;
  String? image;

  UserModel({
    this.uid,
    this.email,
    this.name,
    this.address,
    this.image,
    this.token,
  });

  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      address: map['address'],
      image: map['image'],
      token: map['token'],
    );
  }

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'email': email,
        'name': name,
        'address': address,
        'image': image,
        'token': token,
      };
}

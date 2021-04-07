// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';

part 'userModel.g.dart';


User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());


@HiveType(typeId: 0)
class User  extends HiveObject{  

    @HiveField(0)
    int id;
    
    @HiveField(1)
    String name;

    @HiveField(2)
    String phone;
  
    @HiveField(3)
    String email;

    @HiveField(4)
    String gender;
  
    @HiveField(5)
    String dob;
  
    @HiveField(6)
    String image;
  
    @HiveField(7)
    int paymentId;

 User({
        this.id,
        this.name,
        this.phone,
        this.email,
        this.gender,
        this.dob,
        this.image,
        this.paymentId,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        gender: json["gender"],
        dob: json["dob"],
        image: json["image"],
        paymentId: json["payment_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "email": email,
        "gender": gender,
        "dob": dob,
        "image": image,
        "payment_id": paymentId,
    };
}

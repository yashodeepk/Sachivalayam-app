// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

import 'package:ap_admin_portal/utils/enums.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? ward;
  String? zone;
  String? sachivalyam;
  String? password;
  String? gender;
  int? age;
  UserRole? userRole;
  String? accessToken;
  String? supervisor;
  List<String>? workingSlots;
  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.ward,
    this.zone,
    this.sachivalyam,
    this.gender,
    this.age,
    this.password,
    this.userRole,
    this.accessToken,
    this.supervisor,
    this.workingSlots,
  });

  User.updateWorker({
    this.name,
    this.email,
    this.phone,
    this.gender,
    this.age,
    this.workingSlots,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      phone: json["phone"],
      ward: json["ward"],
      zone: json["zone"],
      sachivalyam: json["sachivalyam"],
      gender: json["gender"],
      age: json["age"],
      userRole: userRoleValues.map![json["roles"]],
      accessToken: json["accessToken"]);

  factory User.fromWorker(Map<String, dynamic> json) => User(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        ward: json["ward"],
        zone: json["zone"],
        sachivalyam: json["sachivalyam"],
        gender: json["gender"],
        age: json["age"],
        userRole: userRoleValues.map![json["roles"]],
        workingSlots: json["workingSlots"] == null ? [] : List<String>.from(json["workingSlots"]!.map((x) => x)),
        supervisor: json["inspector"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "ward": ward,
        "zone": zone,
        "sachivalyam": sachivalyam,
        "gender": gender,
        "age": age,
        "roles": userRoleValues.reverse[userRole],
        "accessToken": accessToken,
        "workingSlots": workingSlots == null ? [] : List<dynamic>.from(workingSlots!.map((x) => x)),
        "inspector": supervisor,
      };

  Map<String, dynamic> toWorker() => {
        "_id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "ward": ward,
        "zone": zone,
        "sachivalyam": sachivalyam,
        "password": password ?? '',
        "gender": gender,
        "age": age,
        "roles": 'worker',
        "workingSlots": workingSlots == null ? [] : List<dynamic>.from(workingSlots!.map((x) => x)),
        "supervisor": supervisor,
      };

  Map<String, dynamic> updateWorker() => {
        "name": name,
        "email": email,
        "phone": phone,
        "gender": gender,
        "age": age,
        "workingSlots": workingSlots == null ? [] : List<dynamic>.from(workingSlots!.map((x) => x)),
      };
}

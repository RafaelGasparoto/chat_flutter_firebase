import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  String? uid;
  String? email;
  String? name;
  List<String>? friends;
  List<String>? groups;

  User({this.uid, this.email, this.name, this.friends, this.groups});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
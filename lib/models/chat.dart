import 'package:chat_flutter_firebase/models/message.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat.g.dart';

@JsonSerializable()
class Chat {
  String? id;
  String? name;
  String? description;
  bool? isGroup;
  List<String>? participants;
  List<Message>? messages;

  Chat({this.id, this.participants, this.name, this.description, this.isGroup, this.messages});
  
  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
  Map<String, dynamic> toJson() => _$ChatToJson(this);
}

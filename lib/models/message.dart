import 'package:chat_flutter_firebase/utils/timestamp_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'message.g.dart';

enum MessageType { Text, Image }

@JsonSerializable()
class Message {
  String? senderId;
  String? content;
  MessageType? messageType;
  String? senderName;
  @TimestampConverter()
  Timestamp? sentAt;

  Message({this.senderId, this.senderName, this.content, this.messageType, this.sentAt});

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}

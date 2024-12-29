
import 'package:json_annotation/json_annotation.dart';
part 'friend_request.g.dart';

@JsonSerializable()
class FriendRequest {
  String? senderId;
  String? senderName;
  String? senderEmail;
  String? receiverId;

  FriendRequest({this.senderId, this.senderName, this.senderEmail, this.receiverId});

  factory FriendRequest.fromJson(Map<String, dynamic> json) => _$FriendRequestFromJson(json);
  Map<String, dynamic> toJson() => _$FriendRequestToJson(this);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendRequest _$FriendRequestFromJson(Map<String, dynamic> json) =>
    FriendRequest(
      senderId: json['senderId'] as String?,
      senderName: json['senderName'] as String?,
      senderEmail: json['senderEmail'] as String?,
      receiverId: json['receiverId'] as String?,
    );

Map<String, dynamic> _$FriendRequestToJson(FriendRequest instance) =>
    <String, dynamic>{
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'senderEmail': instance.senderEmail,
      'receiverId': instance.receiverId,
    };

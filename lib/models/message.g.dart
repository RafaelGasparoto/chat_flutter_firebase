// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      senderId: json['senderId'] as String?,
      senderName: json['senderName'] as String?,
      content: json['content'] as String?,
      messageType:
          $enumDecodeNullable(_$MessageTypeEnumMap, json['messageType']),
      sentAt: const TimestampConverter().fromJson(json['sentAt']),
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'senderId': instance.senderId,
      'content': instance.content,
      'messageType': _$MessageTypeEnumMap[instance.messageType],
      'senderName': instance.senderName,
      'sentAt': _$JsonConverterToJson<dynamic, Timestamp>(
          instance.sentAt, const TimestampConverter().toJson),
    };

const _$MessageTypeEnumMap = {
  MessageType.Text: 'Text',
  MessageType.Image: 'Image',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);

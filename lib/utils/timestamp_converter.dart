import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class TimestampConverter implements JsonConverter<Timestamp, dynamic> {
  const TimestampConverter();

  @override
  Timestamp fromJson(dynamic json) {
    return json is Timestamp
        ? json
        : Timestamp.fromMillisecondsSinceEpoch(json as int);
  }

  @override
  dynamic toJson(Timestamp object) => object.millisecondsSinceEpoch;
}
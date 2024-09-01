import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hiring_task/constants/FirestoreConstants.dart';
import 'package:hiring_task/firebase/FIrebase.dart';

class EventItem extends FirestoreDatabase {
  String id;
  String createdBy;
  String title;
  LatLng coordinates;
  String description;
  String location;
  DateTime eventTime;
  String? pdfFile;
  List<String>? metadata;
  bool status;
  EventItem({
    required this.createdBy,
    required this.title,
    required this.coordinates,
    required this.description,
    required this.eventTime,
    required this.location,
    this.pdfFile,
    this.status = true,
    this.id = '',
    this.metadata,
  }) : super(collectionName: FirestoreConstants.events);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'createdBy': createdBy,
      'title': title,
      'location': location,
      'coordinates': coordinates.toJson(),
      'description': description,
      'metadata': metadata?.map((x) => x).toList(),
      'pdfFile': pdfFile,
      'eventTime': eventTime.millisecondsSinceEpoch,
      'status': status,
    };
  }

  factory EventItem.fromMap(QueryDocumentSnapshot doc) {
    var map = doc.data() as Map<String, dynamic>;
    return EventItem(
      id: doc.id,
      status: map['status'] ?? true,
      pdfFile: map['pdfFile'],
      createdBy: map['createdBy'] ?? '',
      title: map['title'] as String,
      location: map['location'] as String,
      description: map['description'] as String,
      eventTime: DateTime.fromMillisecondsSinceEpoch(map['eventTime']),
      coordinates: LatLng(map['coordinates'][0], map['coordinates'][1]),
    );
  }

  String toJson() => json.encode(toMap());
}

import 'package:flutter/material.dart';
import 'package:hiring_task/firebase/FirebaseServices.dart';
import 'package:hiring_task/models/RentalItem.dart';
import 'package:hiring_task/models/User.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

final FirebaseStreamService _firebaseStream = FirebaseStreamService();
final _logger = Logger();
Widget dashboardAppState({required Widget child}) {
  return MultiProvider(
    providers: [
      StreamProvider<List<UserData>>.value(
        initialData: const [],
        value: _firebaseStream.readUsers(),
        catchError: (context, error) {
          _logger.e(error, error: "Error while reading automations");
          return [];
        },
      ),
      StreamProvider<List<EventItem>>.value(
        initialData: const [],
        value: _firebaseStream.readEvents(),
        catchError: (context, error) {
          _logger.e(error, error: "Error while reading automations");
          return [];
        },
      ),
    ],
    child: child,
  );
}

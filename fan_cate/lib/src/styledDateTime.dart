
import 'package:cloud_firestore/cloud_firestore.dart';

String currTimeStyled(){
  DateTime now = DateTime.now();
  return "${now.hour}:${now.minute} ${now.day}/${now.month}/${now.year}";
}

String timeSinceEpoch(){
  return "${Timestamp.now().millisecondsSinceEpoch}";
}

import 'package:flutter/material.dart';
import 'package:tqnia_chat_app_task/chat_app.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter(); // Initialize Hive

  await Hive.openBox('chat_history'); // Open a Hive box to store chat history
  runApp(const ChatApp());
}

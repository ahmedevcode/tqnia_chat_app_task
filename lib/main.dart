import 'package:flutter/material.dart';
import 'package:tqnia_chat_app_task/chat_app.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('chat_history');
  runApp(const ChatApp());
}

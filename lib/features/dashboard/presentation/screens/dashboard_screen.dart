import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tqnia_chat_app_task/core/routes/routes.dart';
import 'package:hive/hive.dart';
import 'package:tqnia_chat_app_task/features/dashboard/presentation/controller/theme_cubit.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  const DashboardScreen({super.key, required this.toggleTheme});

  @override
  // ignore: library_private_types_in_public_api
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<String> chatHistory = [];

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  Future<void> _loadChatHistory() async {
    var box = Hive.box('chat_history');
    setState(() {
      chatHistory = List<String>.from(box.values);
    });
  }

  Future<void> clearChatHistory() async {
    var box = Hive.box('chat_history');
    await box.clear();
    _loadChatHistory();
  }

  Future<void> _editQuestion(int index, String newQuestion) async {
    var box = Hive.box('chat_history');
    await box.putAt(index, newQuestion);
    _loadChatHistory();
  }

  Future<void> _deleteQuestion(int index) async {
    var box = Hive.box('chat_history');
    await box.deleteAt(index);
    _loadChatHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        leading: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Theme.of(context).primaryColor),
            ),
          ),
          child: IconButton(
            icon: Icon(Icons.messenger,
                color: Theme.of(context).textTheme.bodyLarge?.color),
            onPressed: () {},
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          Container(
            height: 100.h,
            decoration: BoxDecoration(
              border: Border(
                  bottom:
                      BorderSide(color: Theme.of(context).primaryColorLight)),
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(color: Theme.of(context).primaryColorLight)),
              ),
              child: Row(
                children: [
                  SizedBox(width: 80.w),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.conversition,
                          arguments: widget.toggleTheme);
                    },
                    child: Text(
                      'New chat',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
                  SizedBox(width: 200.w),
                  Icon(Icons.arrow_forward_ios,
                      color: Theme.of(context).textTheme.bodyLarge?.color),
                ],
              ),
            ),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            border: Border(
          left: BorderSide(color: Theme.of(context).primaryColorLight),
          bottom: BorderSide(color: Theme.of(context).primaryColorLight),
          right: BorderSide(color: Theme.of(context).primaryColorLight),
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: chatHistory.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 12.w),
                          Icon(Icons.messenger,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.color), // Chat Icon
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              chatHistory[index],
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color),
                            onPressed: () {
                              _showEditDialog(
                                  context, index, chatHistory[index]);
                            },
                          ),
                        ],
                      ),
                      Divider(color: Theme.of(context).primaryColorLight),
                    ],
                  );
                },
              ),
            ),
            TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColorLight,
                textStyle: const TextStyle(fontSize: 16),
              ),
              onPressed: () async {
                await clearChatHistory();
              },
              icon: const Icon(Icons.delete),
              label: const Text('Clear conversations'),
            ),
            TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColorLight,
                textStyle: TextStyle(fontSize: 16.sp),
              ),
              onPressed: () {},
              icon: const Icon(Icons.person),
              label: Row(
                children: [
                  const Text('Upgrade to Plus'),
                  SizedBox(
                    width: 120.w,
                  ),
                  TextButton(
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(const Color(0xff887B06))),
                      onPressed: () {},
                      child: Text(
                        'News',
                        style: TextStyle(
                          color: Theme.of(context).primaryColorLight,
                        ),
                      ))
                ],
              ),
            ),
            TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColorLight,
                textStyle: const TextStyle(fontSize: 16),
              ),
              onPressed: () {
                context.read<ThemeCubit>().toggleTheme();

                widget.toggleTheme;
              },
              icon: const Icon(Icons.light_mode),
              label: const Text('Light Mode'),
            ),
            TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColorLight,
                textStyle: const TextStyle(fontSize: 16),
              ),
              onPressed: () {
                Navigator.pushNamed(context, Routes.conversition);
              },
              icon: const Icon(Icons.update),
              label: const Text('Updates & FAQ'),
            ),
            TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
                textStyle: const TextStyle(fontSize: 16),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm Logout'),
                      content: const Text('Are you sure you want to log out?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Logout'),
                          onPressed: () {
                            Navigator.of(context).pop();

                            SystemNavigator.pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text('Log out'),
            )
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, int index, String question) {
    TextEditingController controller = TextEditingController(text: question);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Question"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: "Question"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _editQuestion(index, controller.text);
                Navigator.of(context).pop();
              },
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.green),
              ),
            ),
            TextButton(
              onPressed: () {
                _deleteQuestion(index);
                Navigator.of(context).pop();
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

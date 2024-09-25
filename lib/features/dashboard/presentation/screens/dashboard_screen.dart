import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tqnia_chat_app_task/chat_app.dart';
import 'package:tqnia_chat_app_task/core/routes/routes.dart';
import 'package:tqnia_chat_app_task/core/theming/colors.dart';
import 'package:hive/hive.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<String> chatHistory = [];

  @override
  void initState() {
    super.initState();
    _loadChatHistory(); // Load chat history when the widget initializes
  }

  Future<void> _loadChatHistory() async {
    var box = Hive.box('chat_history');
    setState(() {
      chatHistory =
          List<String>.from(box.values); // Update the chat history state
    });
  }

  Future<void> clearChatHistory() async {
    var box = Hive.box('chat_history');
    await box.clear(); // Clear all entries in the Hive box
    print('Chat history cleared');
    _loadChatHistory(); // Reload chat history after clearing
  }

  Future<void> _editQuestion(int index, String newQuestion) async {
    var box = Hive.box('chat_history');
    await box.putAt(index, newQuestion); // Update the specific question in Hive
    _loadChatHistory(); // Reload chat history after editing
  }

  Future<void> _deleteQuestion(int index) async {
    var box = Hive.box('chat_history');
    await box.deleteAt(index); // Delete the specific question from Hive
    _loadChatHistory(); // Reload chat history after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Kcolor.conversitioncolor,
      appBar: AppBar(
        leading: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.white54),
            ),
          ),
          child: IconButton(
            icon: const Icon(Icons.messenger, color: Kcolor.mywhite),
            onPressed: () {},
          ),
        ),
        backgroundColor: Kcolor.conversitioncolor,
        actions: [
          Container(
            height: 100,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white54)),
            ),
            child: Row(
              children: [
                const SizedBox(width: 25),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.conversition);
                  },
                  child: Title(
                    color: Kcolor.mywhite,
                    child: Text(
                      'New chat',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Kcolor.mywhite),
                    ),
                  ),
                ),
                SizedBox(width: 200),
                Icon(Icons.arrow_forward_ios, color: Kcolor.mywhite),
              ],
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 300,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white54)),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: chatHistory.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 12,
                              ),
                              Icon(Icons.messenger,
                                  color: Kcolor.mywhite), // Chat Icon
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  chatHistory[index],
                                  style: TextStyle(color: Kcolor.mywhite),
                                ), // Question Text
                              ),
                              IconButton(
                                icon: Icon(Icons.edit,
                                    color: Kcolor.mywhite), // Settings Icon
                                onPressed: () {
                                  _showEditDialog(
                                      context, index, chatHistory[index]);
                                },
                              ),
                            ],
                          ),
                          Divider(color: Colors.white54), // Divider line
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white60,
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
              foregroundColor: Colors.white60,
              textStyle: const TextStyle(fontSize: 16),
            ),
            onPressed: () {},
            icon: const Icon(Icons.person),
            label: Row(
              children: [
                const Text('Upgrade to Plus'),
                SizedBox(
                  width: 80.w,
                ),
                TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(const Color(0xff887B06))),
                    onPressed: () {},
                    child: const Text(
                      'News',
                      style: TextStyle(
                        color: Colors.orange,
                      ),
                    ))
              ],
            ),
          ),
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white60,
              textStyle: const TextStyle(fontSize: 16),
            ),
            onPressed: () {},
            icon: const Icon(Icons.light_mode),
            label: const Text('Light Mode'),
          ),
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white60,
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
            onPressed: () {},
            icon: const Icon(Icons.logout),
            label: const Text('Log out'),
          )
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, int index, String question) {
    TextEditingController controller = TextEditingController(text: question);
    showDialog(
      barrierColor: Kcolor.mainbackgroundcolor,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Kcolor.conversitioncolor,
          title: Text(
            "Edit Question",
            style: TextStyle(
              color: Kcolor.mywhite,
            ),
          ),
          content: TextField(
            controller: controller,
            style: TextStyle(color: Colors.white), // Change text color to white
            decoration: InputDecoration(
              labelText: "Question",
              labelStyle:
                  TextStyle(color: Colors.white), // Change label color to white
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.white), // Change border color to white
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.green), // Change focused border color
              ),
              filled: true,
              fillColor: Kcolor
                  .conversitioncolor, // Change fill color to match your theme
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _editQuestion(index, controller.text); // Edit question
                Navigator.of(context).pop();
              },
              child: Text(
                "Save",
                style: TextStyle(color: Colors.green),
              ),
            ),
            TextButton(
              onPressed: () {
                _deleteQuestion(index); // Delete question
                Navigator.of(context).pop();
              },
              child: Text(
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

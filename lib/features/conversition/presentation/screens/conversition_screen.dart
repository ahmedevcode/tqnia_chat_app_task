import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tqnia_chat_app_task/core/theming/colors.dart';
import 'package:tqnia_chat_app_task/core/util/constant.dart';
import 'package:tqnia_chat_app_task/features/conversition/data/models/chat_model.dart';
import 'package:tqnia_chat_app_task/features/conversition/presentation/controller/chat_cubit.dart';

class Conversition extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Kcolor.mywhite),
            onPressed: () => Navigator.of(context).pop(),
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.white54),
            ),
          ),
        ),
        actions: [
          Container(
            height: 80,
            child: Row(
              children: [
                Text(
                  'Back',
                  style: TextStyle(color: Kcolor.mywhite),
                ),
                SizedBox(width: 240),
                Image.asset(AppConstants.imagepath),
                SizedBox(width: 30),
              ],
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white54),
              ),
            ),
          ),
        ],
        backgroundColor: Kcolor.conversitioncolor,
      ),
      body: Container(
        color: Kcolor.conversitioncolor,
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  if (state.messages.isEmpty) {
                    return Center(
                      child: Text(
                        'Type a question to start the conversation',
                        style: TextStyle(color: Colors.white54, fontSize: 18),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    itemCount: state.isTyping
                        ? state.messages.length + 1
                        : state.messages.length,
                    itemBuilder: (context, index) {
                      if (index == state.messages.length) {
                        return _buildTypingIndicator();
                      }
                      final isUserMessage = state.messages[index].isUser;
                      return Align(
                        alignment: isUserMessage
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: _buildMessageBubble(
                            state.messages[index], isUserMessage, context),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white38,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                hintText: 'Message Chat Gpt',
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 16),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (_controller.text.isNotEmpty) {
                                context
                                    .read<ChatCubit>()
                                    .sendMessage(_controller.text);
                                _controller.clear();
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xff10A37F),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.all(12),
                              child: Transform.rotate(
                                angle: 200,
                                child: Icon(Icons.send, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Define the _buildMessageBubble method inside the Conversition class
  Widget _buildMessageBubble(
      ChatMessage message, bool isUserMessage, BuildContext context) {
    return Column(
      crossAxisAlignment:
          isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          decoration: BoxDecoration(
            color: isUserMessage ? Colors.green : Colors.grey.shade300,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(30.0),
              bottomLeft: isUserMessage
                  ? const Radius.circular(30.0)
                  : const Radius.circular(0.0),
              topRight: const Radius.circular(30.0),
              bottomRight: !isUserMessage
                  ? const Radius.circular(30.0)
                  : const Radius.circular(0.0),
            ),
          ),
          child: Text(
            message.message, // Ensure 'message' is accessed correctly
            style: const TextStyle(color: Colors.black),
          ),
        ),
        // Only show buttons and regenerate response for AI (non-user) messages
        if (!isUserMessage) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.thumb_up, color: Kcolor.mywhite),
                onPressed: () {
                  // Handle like logic here
                  print('Liked message: ${message.message}');
                },
              ),
              IconButton(
                icon: const Icon(Icons.thumb_down, color: Kcolor.mywhite),
                onPressed: () {
                  // Handle dislike logic here
                  print('Disliked message: ${message.message}');
                },
              ),
              IconButton(
                icon: const Icon(Icons.copy, color: Kcolor.mywhite),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: message.message));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Message copied to clipboard')),
                  );
                },
              ),
            ],
          ),
          TextButton.icon(
            onPressed: () {
              context.read<ChatCubit>().regenerateResponse();
            },
            icon: const Icon(Icons.refresh, color: Colors.black),
            label: const Text(
              'Regenerate Response',
              style: TextStyle(color: Colors.black),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.white24,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            ),
          ),
        ],
      ],
    );
  }

  // Typing indicator widget
  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.deepPurple[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                AnimatedDot(),
                SizedBox(width: 5),
                AnimatedDot(delay: Duration(milliseconds: 200)),
                SizedBox(width: 5),
                AnimatedDot(delay: Duration(milliseconds: 400)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Three dots animation
class AnimatedDot extends StatefulWidget {
  final Duration delay;

  AnimatedDot({this.delay = Duration.zero});

  @override
  _AnimatedDotState createState() => _AnimatedDotState();
}

class _AnimatedDotState extends State<AnimatedDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

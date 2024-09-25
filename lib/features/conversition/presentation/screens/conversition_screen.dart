import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:tqnia_chat_app_task/core/routes/routes.dart';
import 'package:tqnia_chat_app_task/core/util/constant.dart';
import 'package:tqnia_chat_app_task/features/conversition/data/models/chat_model.dart';
import 'package:tqnia_chat_app_task/features/conversition/presentation/controller/chat_cubit.dart';
import 'package:tqnia_chat_app_task/features/conversition/presentation/screens/widgets/custom_animated_dot.dart';

class Conversition extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  Conversition({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Theme.of(context).primaryColorLight),
            ),
          ),
          child: IconButton(
              icon: Icon(Icons.arrow_back_ios,
                  color: Theme.of(context).textTheme.bodyLarge?.color),
              onPressed: () {
                Navigator.pushNamed(context, Routes.dashboard);
              }),
        ),
        actions: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Theme.of(context).primaryColorLight),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Back',
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color),
                ),
                SizedBox(width: 240.w),
                Image.asset(
                  AppConstants.imagepath,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                SizedBox(width: 30.w),
              ],
            ),
          ),
        ],
        backgroundColor: Theme.of(context).secondaryHeaderColor,
      ),
      body: Container(
        color: Theme.of(context).secondaryHeaderColor,
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  if (state.messages.isEmpty) {
                    return Center(
                      child: Text(
                        'Type a question to start the conversation',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            fontSize: 18.sp),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    itemCount: state.isTyping
                        ? state.messages.length + 1
                        : state.messages.length,
                    itemBuilder: (context, index) {
                      if (index == state.messages.length) {
                        return _buildTypingIndicator(context);
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
                        color: Theme.of(context).primaryColorLight,
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
                                    EdgeInsets.symmetric(horizontal: 16.w),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (_controller.text.isNotEmpty) {
                                var box = Hive.box('chat_history');
                                String question = _controller.text;

                                box.add(question);
                                //  print('Question saved: $question');

                                context.read<ChatCubit>().sendMessage(question);
                                _controller.clear();
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xff10A37F),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Transform.rotate(
                                angle: 200,
                                child: Icon(Icons.send,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(
      ChatMessage message, bool isUserMessage, BuildContext context) {
    return Column(
      crossAxisAlignment:
          isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 40.w),
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
            message.message,
            style: const TextStyle(color: Colors.black),
          ),
        ),
        if (!isUserMessage) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.thumb_up,
                    color: Theme.of(context).textTheme.bodyLarge?.color),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.thumb_down,
                    color: Theme.of(context).textTheme.bodyLarge?.color),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.copy,
                    color: Theme.of(context).textTheme.bodyLarge?.color),
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
            icon:
                Icon(Icons.refresh, color: Theme.of(context).primaryColorLight),
            label: const Text(
              'Regenerate Response',
              style: TextStyle(color: Colors.black),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColorLight,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTypingIndicator(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize:
                  MainAxisSize.min, // Ensure Row takes the minimum size needed
              children: [
                const AnimatedDot(),
                SizedBox(width: 5.w),
                const AnimatedDot(delay: Duration(milliseconds: 200)),
                SizedBox(width: 5.w),
                const AnimatedDot(delay: Duration(milliseconds: 400)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

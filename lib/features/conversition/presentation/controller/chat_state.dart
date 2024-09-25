part of 'chat_cubit.dart';

@immutable
class ChatState {
  final List<ChatMessage> messages;
  final bool isTyping;

  ChatState({required this.messages, required this.isTyping});

  ChatState copyWith({List<ChatMessage>? messages, bool? isTyping}) {
    return ChatState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}

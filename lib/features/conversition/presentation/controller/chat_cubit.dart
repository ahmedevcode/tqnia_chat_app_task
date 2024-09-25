import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tqnia_chat_app_task/features/conversition/data/data_sources/Apis/GenerativeChatService.dart';
import 'package:tqnia_chat_app_task/features/conversition/data/models/chat_model.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final GenerativeChatService _generativeChatService;
  String? _lastUserMessage; // Store the last user message for regeneration

  ChatCubit(this._generativeChatService)
      : super(ChatState(messages: [], isTyping: false));

  void sendMessage(String message) async {
    // Store the last user message for possible regeneration
    _lastUserMessage = message;

    // Emit the user's message
    emit(state.copyWith(messages: [
      ...state.messages,
      ChatMessage(message: message, isUser: true)
    ], isTyping: true));

    // Generate AI response
    final response = await _generateAIResponse(message);

    // Emit the AI's response
    emit(state.copyWith(messages: [
      ...state.messages,
      ChatMessage(message: response, isUser: false)
    ], isTyping: false));
  }

  void regenerateResponse() async {
    // Check if there's a last user message to regenerate
    if (_lastUserMessage != null) {
      // Set isTyping to true to show typing animation
      emit(state.copyWith(isTyping: true));

      // Generate a new AI response for the last user message
      final newResponse = await _generateAIResponse(_lastUserMessage!);

      // Update the messages list by replacing the last AI response with the new one
      final updatedMessages = [...state.messages];
      updatedMessages[updatedMessages.length - 1] =
          ChatMessage(message: newResponse, isUser: false);

      // Emit the new state with the updated messages and set isTyping to false
      emit(state.copyWith(messages: updatedMessages, isTyping: false));
    }
  }

  // Improved _generateAIResponse method with error logging
  Future<String> _generateAIResponse(String message) async {
    try {
      // Use the GenerativeChatService to get the AI response
      final aiResponse = await _generativeChatService.sendMessage(message);
      print('AI response: $aiResponse'); // Debugging
      return aiResponse;
    } catch (e) {
      print('Error in _generateAIResponse: $e'); // Log the error
      return "Sorry, something went wrong. Please try again.";
    }
  }
}

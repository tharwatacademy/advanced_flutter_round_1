import 'package:dio/dio.dart';
import 'package:flutter_application_1/features/chat/data/models/chat_message_model.dart';

import '../../../../core/networking/api_client.dart';

class GemenaiChatService {
  final DioApiClient _apiClient = DioApiClient(
    baseUrl: 'https://generativelanguage.googleapis.com/v1beta/models',
  );

  Future<ChatMessageModel> sendMessage({
    required List<ChatMessageModel> messages,
  }) async {
    final response = await _apiClient.post(
      '/gemini-3-flash-preview:generateContent',
      data: {"contents": messages.map((message) => message.toJson()).toList()},
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "x-goog-api-key": "AIzaSyDfx1eQfZUQyxVBZUBmZkqyb-_OKSo2hWo",
        },
      ),
    );

    return ChatMessageModel.fromJson(response['candidates'][0]['content']);
  }
}

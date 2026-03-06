import 'package:flutter_application_1/core/mixins/chat_service_validation_mixin.dart';

import '../../domain/chat_repo.dart';
import '../models/chat_message_model.dart';
import '../services/gemenai_chat_service.dart';

class GemenaiChatRepoImpl extends ChatRepo with ChatServiceValidationMixin {
  final GemenaiChatService _gemenaiChatService;

  GemenaiChatRepoImpl({required GemenaiChatService gemenaiChatService})
    : _gemenaiChatService = gemenaiChatService;
  @override
  Future<ChatMessageModel> sendMessage({
    required List<ChatMessageModel> messages,
  }) async {
    validateInput(messages);

    final response = await _gemenaiChatService.sendMessage(messages: messages);

    validateOutput(response);

    return response;
  }

}

import '../../domain/chat_repo.dart';
import '../models/chat_message_model.dart';
import '../services/gemenai_chat_service.dart';

class GemenaiChatRepoImpl extends ChatRepo {
  final GemenaiChatService _gemenaiChatService;

  GemenaiChatRepoImpl({required GemenaiChatService gemenaiChatService})
    : _gemenaiChatService = gemenaiChatService;
  @override
  Future<ChatMessageModel> sendMessage({
    required List<ChatMessageModel> messages,
  }) async {
    // ── Input validation ───────────────────────────────────────────────
    if (messages.isEmpty) {
      throw ArgumentError('Messages list cannot be empty.');
    }

    final lastMessage = messages.last;
    if (lastMessage.parts.isEmpty ||
        lastMessage.parts.every((p) => p.text.trim().isEmpty)) {
      throw ArgumentError('The last message must contain non-empty text.');
    }

    // ── Service call ───────────────────────────────────────────────────
    final response = await _gemenaiChatService.sendMessage(messages: messages);

    // ── Output validation ──────────────────────────────────────────────
    if (response.parts.isEmpty) {
      throw FormatException('API returned a message with no parts.');
    }

    if (response.displayText.trim().isEmpty) {
      throw FormatException('API returned an empty response text.');
    }

    return response;
  }
}

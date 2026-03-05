import 'package:flutter_application_1/features/chat/data/models/chat_message_model.dart';
import 'package:flutter_application_1/features/chat/data/models/chat_message_part_model.dart';
import 'package:flutter_application_1/features/chat/data/repos/gemenai_chat_repo_impl.dart';
import 'package:flutter_application_1/features/chat/data/services/gemenai_chat_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class GemenaiChatServiceMock extends Mock implements GemenaiChatService {}

void main() {
  late GemenaiChatServiceMock gemenaiChatServiceMock;
  late GemenaiChatRepoImpl gemenaiChatRepoImpl;

  setUp(() {
    gemenaiChatServiceMock = GemenaiChatServiceMock();
    gemenaiChatRepoImpl = GemenaiChatRepoImpl(
      gemenaiChatService: gemenaiChatServiceMock,
    );
  });

  group('Validate Input of Send Message', () {
    test("throw argument error when input list is empty ", () {
      expect(
        () => gemenaiChatRepoImpl.sendMessage(messages: []),
        throwsA(isA<ArgumentError>()),
      );
    });

    test("throws argument error if last message is empty", () {
      expect(
        () => gemenaiChatRepoImpl.sendMessage(
          messages: [ChatMessageModel(parts: [], role: "user")],
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test("throws argument error text in part is empty ", () {
      expect(
        () => gemenaiChatRepoImpl.sendMessage(
          messages: [
            ChatMessageModel(
              parts: [ChatMessagePartModel(text: "")],
              role: "user",
            ),
          ],
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group("Test output of send message", () {
    test("response parts is empty", () async {
      when(
        () => gemenaiChatServiceMock.sendMessage(
          messages: any(named: "messages"),
        ),
      ).thenAnswer((_) async => ChatMessageModel(parts: [], role: "user"));
      expect(
        () => gemenaiChatRepoImpl.sendMessage(
          messages: [
            ChatMessageModel(
              parts: [ChatMessagePartModel(text: "hello")],
              role: "user",
            ),
          ],
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test("display test is empty", () async {
      when(
        () => gemenaiChatServiceMock.sendMessage(
          messages: any(named: "messages"),
        ),
      ).thenAnswer(
        (_) async => ChatMessageModel(
          parts: [ChatMessagePartModel(text: '')],
          role: "user",
        ),
      );
      expect(
        () => gemenaiChatRepoImpl.sendMessage(
          messages: [
            ChatMessageModel(
              parts: [ChatMessagePartModel(text: "hello")],
              role: "user",
            ),
          ],
        ),
        throwsA(isA<FormatException>()),
      );
    });
  });
}

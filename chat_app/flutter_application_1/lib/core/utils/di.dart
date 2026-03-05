import 'package:get_it/get_it.dart';

import '../../features/chat/data/repos/gemenai_chat_repo_impl.dart';
import '../../features/chat/data/services/gemenai_chat_service.dart';
import '../../features/chat/domain/chat_repo.dart';
import '../../features/chat/ui/cubits/chat_cubit/chat_cubit.dart';
import '../networking/api_client.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  // ── Core ───────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<DioApiClient>(() => DioApiClient());

  // ── Services ───────────────────────────────────────────────────────────
  getIt.registerLazySingleton<GemenaiChatService>(
    () => GemenaiChatService(apiClient: getIt<DioApiClient>()),
  );

  // ── Repos ──────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<ChatRepo>(
    () => GemenaiChatRepoImpl(gemenaiChatService: getIt<GemenaiChatService>()),
  );

  // ── Cubits ─────────────────────────────────────────────────────────────
  getIt.registerFactory<SendMessageCubit>(
    () => SendMessageCubit(chatRepo: getIt<ChatRepo>()),
  );
}

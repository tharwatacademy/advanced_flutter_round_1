import 'package:get_it/get_it.dart';

import '../../config/app_config.dart';
import '../../features/auth/data/firebase_auth_repo_impl.dart';
import '../../features/auth/domain/auth_repo.dart';
import '../../features/auth/ui/cubits/auth_cubit/auth_cubit.dart';
import '../../features/chat/data/repos/gemenai_chat_repo_impl.dart';
import '../../features/chat/data/services/gemenai_chat_service.dart';
import '../../features/chat/domain/chat_repo.dart';
import '../../features/chat/ui/cubits/chat_cubit/chat_cubit.dart';
import '../networking/api_client.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  // ── Core ───────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<DioApiClient>(
    () => DioApiClient(baseUrl: getIt<AppConfig>().baseUrl),
  );

  // ── Services ───────────────────────────────────────────────────────────
  getIt.registerLazySingleton<GemenaiChatService>(
    () => GemenaiChatService(apiClient: getIt<DioApiClient>()),
  );

  // ── Repos ──────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<AuthRepo>(() => FirebaseAuthRepoImpl());

  getIt.registerLazySingleton<ChatRepo>(
    () => GemenaiChatRepoImpl(gemenaiChatService: getIt<GemenaiChatService>()),
  );

  // ── Cubits ─────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<AuthCubit>(
    () => AuthCubit(authRepo: getIt<AuthRepo>()),
  );
  getIt.registerFactory<SendMessageCubit>(
    () => SendMessageCubit(chatRepo: getIt<ChatRepo>()),
  );
}

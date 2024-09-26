import 'package:ecommerce_starter_app/src/features/authentication/domain/app_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeAuthRepository {
  Stream<AppUser?> authStateChanges() => Stream.value(null); // TODO: Update
  AppUser? get currentUser => null; // TODO: Update

  Future<void> signInWithEmailAndPassword(
      String email, String password) async {}

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {}

  Future<void> signOut() async {}
}

final authRepositoryProvider = Provider<FakeAuthRepository>((ref) {
  return FakeAuthRepository();
});

final authStateChangesProvider = StreamProvider.autoDispose<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});

import 'package:ecommerce_starter_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountScreenController extends StateNotifier<AsyncValue<void>> {
  AccountScreenController({required this.authRepository})
      : super(const AsyncValue<void>.data(null));

  final FakeAuthRepository authRepository;

  Future<void> signOut() async {
    try {
      // Set state to loading.
      state = const AsyncValue<void>.loading();

      // Sign out (using auth repository).
      await authRepository.signOut();

      // If success, set state to data.
      state = const AsyncValue<void>.data(null);
    } catch (e, st) {
      // If error, set state to error.
      state = AsyncValue<void>.error(e, st);
    }
  }
}

final accountScreenControllerProvider = StateNotifierProvider.autoDispose<
    AccountScreenController, AsyncValue<void>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AccountScreenController(
    authRepository: authRepository,
  );
});

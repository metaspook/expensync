import 'dart:async';

// import 'package:connectivator/connectivator.dart';
import 'package:equatable/equatable.dart';
import 'package:expensync/shared/repositories/repositories.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'app_state.dart';

class AppCubit extends HydratedCubit<AppState> {
  AppCubit({required ExpenseRepo expenseRepo})
      : _expenseRepo = expenseRepo,
        // _connectivator = Connectivator(),
        super(const AppState()) {
    //-- Initialize Connectivity.
    // _connectivitySubscription =
    //     _connectivator.onConnected().listen((record) async {
    //   final (statusMsg, online) = record;
    //   emit(state.copyWith(statusMsg: statusMsg, online: online));
    // });
    //-- Initialize Authentication.
    // _userSubscription = appUserRepo.currentUserStream.listen((record) async {
    //   final (errorMsg, appUser) = record;

    //   if (appUser.isAuthenticated) {
    //     // Update user installationId.
    //     String? errorMsgUpdate;
    //     if (state.installationId != appUser.installationId) {
    //       final userObj = {
    //         'installationId': state.installationId,
    //         'updatedAt': timestampStr(),
    //       };
    //       // Update user on database.
    //       errorMsgUpdate = await appUserRepo.update(appUser.id, value: userObj);
    //     }
    //     errorMsgUpdate == null
    //         ? emit(state.authenticated(appUser))
    //         : emit(state.unauthenticated(errorMsgUpdate));
    //   } else {
    //     emit(state.unauthenticated(errorMsg));
    //   }
    // });
  }

  // bool _connected = false;
  // final Connectivator _connectivator;
  // late final StreamSubscription<(String?, bool)> _connectivitySubscription;
  // late final StreamSubscription<(String?, AppUser)> _userSubscription;
  final ExpenseRepo _expenseRepo;

  Future<void> onConnection({required bool online}) async {
    emit(state.copyWith(syncStatus: SyncStatus.online));

    // Subscribe if get back online
    if (online) _expenseRepo.streamList.listen(print);

    if (online && state.tasks.isNotEmpty) {
      // Do Pending tasks
      emit(state.copyWith(syncStatus: SyncStatus.syncing));
      final newTasks = [...state.tasks];

      // await Future.wait(
      //   state.tasks,
      //   cleanUp: (successValue) => successValue.doPrint('successValue: '),
      // );
      for (final task in state.tasks) {
        await task().then((_) => newTasks.remove(task));
      }
      emit(state.copyWith(syncStatus: SyncStatus.online, tasks: newTasks));
    } else if (online) {
      emit(state.copyWith(syncStatus: SyncStatus.online));
    } else {
      emit(state.copyWith(syncStatus: SyncStatus.offline));
    }
  }

  Future<void> doTask(Task task) async {
    final offlineMode =
        state.syncStatus.isOffline && !state.tasks.contains(task);
    // state.syncStatus.isOffline.doPrint('OfflineMode: ');
    offlineMode
        // Schedule Task
        ? emit(state.copyWith(tasks: [...state.tasks, task]))
        : await task();
  }

  void onGetStarted() {
    emit(state.copyWith(firstLaunch: false));
  }

  void onNavDestinationSelected(int index) {
    emit(state.copyWith(navIndex: index));
  }

  void changeLanguage(AppLanguage language) {
    emit(state.copyWith(language: language));
  }

  @override
  AppState? fromJson(Map<String, dynamic> json) => AppState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(AppState state) => state.toJson();

  @override
  Future<void> close() {
    // _connectivitySubscription.cancel();
    _expenseRepo.dispose();
    return super.close();
  }
}

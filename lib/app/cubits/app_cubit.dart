import 'dart:async';

// import 'package:connectivator/connectivator.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'app_state.dart';

class AppCubit extends HydratedCubit<AppState> {
  AppCubit()
      :
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

  Future<void> onConnection({required bool online}) async {
    emit(state.copyWith(online: online));

    // Do Pending tasks
    if (online && state.tasks.isNotEmpty) {
      print(state.tasks);
      final newTasks = [...state.tasks];
      for (final task in state.tasks) {
        await task().then((_) => print('DONE 1'));
        print('DONE 2');
        newTasks.remove(task);
      }
      emit(state.copyWith(tasks: newTasks));
    }
  }

  Future<void> doTask(Task task) async {
    print('ONLINE ${state.tasks}');
    !state.online && !state.tasks.contains(task)
        ? emit(state.copyWith(tasks: [...state.tasks, task]))
        : await task();
  }

  // void addTask(Task task) {
  //   final newTasks = [...state.tasks, task];
  //   emit(state.copyWith(tasks: newTasks));
  // }

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
    // _userSubscription.cancel();
    // _connectivitySubscription.cancel();
    return super.close();
  }
}

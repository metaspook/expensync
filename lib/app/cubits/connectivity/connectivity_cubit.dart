import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

part 'connectivity_state.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  ConnectivityCubit({required Connectivity connectivityRepo})
      : super(const ConnectivityState()) {
    // Listen to connectivity changes
    print('KIRRWE');
    _connectivitySubscription =
        connectivityRepo.onConnectivityChanged.listen((results) {
      print(results);
      final connected = results.contains(ConnectivityResult.mobile) ||
          results.contains(ConnectivityResult.wifi) ||
          results.contains(ConnectivityResult.ethernet);

      emit(
        connected
            ? state.copyWith(
                status: ConnectivityStatus.connected,
                statusMsg: 'Internet is connected!',
              )
            : state.copyWith(
                status: ConnectivityStatus.disconnected,
                statusMsg: 'Internet is disconnected!',
              ),
      );
    });
  }

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}

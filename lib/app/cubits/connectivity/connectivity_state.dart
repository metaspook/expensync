part of 'connectivity_cubit.dart';

enum ConnectivityStatus { connected, disconnected, unknown }

class ConnectivityState extends Equatable {
  const ConnectivityState({
    this.status = ConnectivityStatus.unknown,
    this.statusMsg,
  });
  final ConnectivityStatus status;
  final String? statusMsg;

  ConnectivityState copyWith({
    ConnectivityStatus? status,
    String? statusMsg,
  }) {
    return ConnectivityState(
      status: status ?? this.status,
      statusMsg: statusMsg ?? this.statusMsg,
    );
  }

  @override
  List<Object?> get props => [status, statusMsg];
}

part of 'connectivity_cubit.dart';

enum ConnectivityStatus { connected, disconnected }

class ConnectivityState extends Equatable {
  const ConnectivityState({
    this.status = ConnectivityStatus.disconnected,
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

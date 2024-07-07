part of 'home_cubit.dart';

enum HomeStatus { initial, failure, success, loading }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.statusMsg,
    this.tabIndex = 0,
    this.pendingCount = 0,
    this.itemCount = 0,
    this.connected = false,
  });

  final HomeStatus status;
  final String? statusMsg;
  final int tabIndex;
  final int pendingCount;
  final int itemCount;
  final bool connected;

  HomeState copyWith({
    HomeStatus? status,
    String? statusMsg,
    int? tabIndex,
    int? pendingCount,
    int? itemCount,
    bool? connected,
  }) {
    return HomeState(
      status: status ?? this.status,
      statusMsg: statusMsg ?? this.statusMsg,
      tabIndex: tabIndex ?? this.tabIndex,
      pendingCount: pendingCount ?? this.pendingCount,
      itemCount: itemCount ?? this.itemCount,
      connected: connected ?? this.connected,
    );
  }

  @override
  List<Object?> get props {
    return [
      status,
      statusMsg,
      tabIndex,
      pendingCount,
      itemCount,
      connected,
    ];
  }
}

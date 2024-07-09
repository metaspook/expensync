part of 'app_cubit.dart';

enum AppStatus {
  // initial,
  loggedIn,
  loggedOut;
  // authenticated,
  // unauthenticated;

  bool get isLoggedIn => this == AppStatus.loggedIn;
}

enum SyncStatus {
  online,
  offline,
  syncing;
  // authenticated,
  // unauthenticated;

  // bool get isLoggedIn => this == AppStatus.loggedIn;
}

enum AppLanguage {
  auto('Auto'),
  arabic('عربي'),
  english('English');

  const AppLanguage(this.title);
  final String title;
}

typedef Task = Future<Object?> Function();

final class AppState extends Equatable {
  const AppState({
    // required this.installationId,
    this.status = AppStatus.loggedOut,
    this.statusMsg,
    this.language = AppLanguage.auto,
    // this.user = AppUser.unauthenticated,
    this.online = false,
    this.firstLaunch = true,
    this.navIndex = 0,
    this.tasks = const [],
  });

  // const AppState.authenticated(AppUser user)
  //     : this._(status: AppStatus.authenticated, user: user);
  // const AppState.unauthenticated() : this._();

  factory AppState.fromJson(Map<String, dynamic> json) {
    // final userJson =
    //     Map.castFrom<dynamic, dynamic, String, dynamic>(json['user'] as Map);
    return AppState(
      // installationId: json['installationId'] as String,
      // user: AppUser.fromJson(json['user'] as Map<String, dynamic>),
      language: AppLanguage.values.byName(json['language'] as String),
      firstLaunch: json['firstLaunch'] as bool,
    );
  }

  // final String installationId;
  final AppStatus status;
  final String? statusMsg;
  final AppLanguage language;
  // final AppUser user;
  final bool online;
  final bool firstLaunch;
  final int navIndex;
  final List<Task> tasks;

  Map<String, dynamic> toJson() => <String, dynamic>{
        // 'installationId': installationId,
        // 'user': user.toJson(),
        'language': language.name,
        'firstLaunch': firstLaunch,
      };

  AppState copyWith({
    String? installationId,
    AppStatus? status,
    AppLanguage? language,
    String? statusMsg,
    // AppUser? user,
    bool? online,
    bool? firstLaunch,
    int? navIndex,
    List<Task>? tasks,
  }) =>
      AppState(
        // installationId: installationId ?? this.installationId,
        status: status ?? this.status,
        language: language ?? this.language,
        statusMsg: this.statusMsg,
        // user: user ?? this.user,
        online: online ?? this.online,
        firstLaunch: firstLaunch ?? this.firstLaunch,
        navIndex: navIndex ?? this.navIndex,
        tasks: tasks ?? this.tasks,
      );

  // Pre-defined state clones.
  // AppState authenticated(AppUser? user) => copyWith(
  //       status: AppStatus.loggedIn,
  //       user: user,
  //     );
  // AppState unauthenticated(String? statusMsg) => copyWith(
  //       status: AppStatus.loggedOut,
  //       user: AppUser.unauthenticated,
  //       statusMsg: statusMsg,
  //     );

  @override
  List<Object?> get props => [
        // installationId,
        status,
        language,
        statusMsg,
        // user,
        online,
        firstLaunch,
        navIndex,
        tasks,
      ];
}

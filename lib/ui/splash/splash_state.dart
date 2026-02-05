class SplashState {
  final bool isAlreadyLogin;

  SplashState({this.isAlreadyLogin = false});

  SplashState copyWith({bool? isAlreadyLogin}) {
    return SplashState(isAlreadyLogin: isAlreadyLogin ?? this.isAlreadyLogin);
  }
}

class SignInState {
  final bool successLogin;
  final bool isLoading;
  final String message;

  SignInState({
    this.successLogin = false,
    this.isLoading = false,
    this.message = "",
  });

  SignInState copyWith({bool? successLogin, bool? isLoading, String? message}) {
    return SignInState(
      successLogin: successLogin ?? this.successLogin,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

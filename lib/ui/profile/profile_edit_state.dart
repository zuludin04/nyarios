class ProfileEditState {
  final String? photo;
  final String? status;
  final String? name;
  final String? email;

  ProfileEditState({
    this.photo = '',
    this.status = '',
    this.name = '',
    this.email = '',
  });

  ProfileEditState copyWith({
    String? photo,
    String? status,
    String? name,
    String? email,
  }) {
    return ProfileEditState(
      photo: photo ?? this.photo,
      status: status ?? this.status,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}

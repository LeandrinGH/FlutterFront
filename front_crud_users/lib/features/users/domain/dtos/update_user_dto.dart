class UpdateUserDto {
  final String? username;
  final String? newEmail;
  final String? password;

  UpdateUserDto({
    this.username,
    this.newEmail,
    this.password,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{'username': username};
    if (newEmail != null) data['newEmail'] = newEmail;
    if (password != null) data['password'] = password;
    return data;
  }
}

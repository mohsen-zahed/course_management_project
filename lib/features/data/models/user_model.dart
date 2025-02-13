class UserModel {
  final int id;
  final String name;
  final String accessToken;
  final String email;

  const UserModel({
    required this.id,
    required this.name,
    required this.accessToken,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user']['id'],
      name: json['user']['name'] ?? '',
      accessToken: json['access_token'] ?? '',
      email: json['user']['email'],
    );
  }
}

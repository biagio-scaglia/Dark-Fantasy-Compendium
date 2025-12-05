class UserProfile {
  final String username;
  final String? pin;

  UserProfile({
    required this.username,
    this.pin,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      username: json['username'] as String,
      pin: json['pin'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'pin': pin,
    };
  }
}



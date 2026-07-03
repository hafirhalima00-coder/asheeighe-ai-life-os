class AuthUser {
  final String id;
  final String email;
  final String? name;
  final String? avatarUrl;
  final bool isEmailVerified;
  final String? authProvider;

  const AuthUser({
    required this.id,
    required this.email,
    this.name,
    this.avatarUrl,
    this.isEmailVerified = false,
    this.authProvider,
  });

  AuthUser copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
    bool? isEmailVerified,
    String? authProvider,
  }) {
    return AuthUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      authProvider: authProvider ?? this.authProvider,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthUser &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email;

  @override
  int get hashCode => id.hashCode ^ email.hashCode;
}

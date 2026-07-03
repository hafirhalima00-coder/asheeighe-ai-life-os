class ComposioIntegration {
  final String id;
  final String name;
  final String description;
  final String? logo;
  final String category;
  final bool isConnected;
  final DateTime? connectedAt;
  final String authType;

  const ComposioIntegration({
    required this.id,
    required this.name,
    required this.description,
    this.logo,
    required this.category,
    this.isConnected = false,
    this.connectedAt,
    this.authType = 'oauth2',
  });

  ComposioIntegration copyWith({
    String? id,
    String? name,
    String? description,
    String? logo,
    String? category,
    bool? isConnected,
    DateTime? connectedAt,
    String? authType,
  }) {
    return ComposioIntegration(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      logo: logo ?? this.logo,
      category: category ?? this.category,
      isConnected: isConnected ?? this.isConnected,
      connectedAt: connectedAt ?? this.connectedAt,
      authType: authType ?? this.authType,
    );
  }
}

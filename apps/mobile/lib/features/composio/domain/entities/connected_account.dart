class ConnectedAccount {
  final String id;
  final String integrationId;
  final String integrationName;
  final String status;
  final DateTime? connectedAt;
  final DateTime? expiresAt;
  final DateTime? lastUsedAt;

  const ConnectedAccount({
    required this.id,
    required this.integrationId,
    required this.integrationName,
    this.status = 'active',
    this.connectedAt,
    this.expiresAt,
    this.lastUsedAt,
  });

  bool get isActive => status == 'active';
  bool get isExpired =>
      expiresAt != null && expiresAt!.isBefore(DateTime.now());

  ConnectedAccount copyWith({
    String? id,
    String? integrationId,
    String? integrationName,
    String? status,
    DateTime? connectedAt,
    DateTime? expiresAt,
    DateTime? lastUsedAt,
  }) {
    return ConnectedAccount(
      id: id ?? this.id,
      integrationId: integrationId ?? this.integrationId,
      integrationName: integrationName ?? this.integrationName,
      status: status ?? this.status,
      connectedAt: connectedAt ?? this.connectedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
    );
  }
}

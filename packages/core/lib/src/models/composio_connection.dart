import 'package:freezed_annotation/freezed_annotation.dart';

part 'composio_connection.freezed.dart';
part 'composio_connection.g.dart';

@freezed
class ComposioConnection with _$ComposioConnection {
  const factory ComposioConnection({
    required String id,
    required String integrationName,
    required String status,
    required DateTime connectedAt,
    DateTime? expiresAt,
  }) = _ComposioConnection;

  factory ComposioConnection.fromJson(Map<String, dynamic> json) =>
      _$ComposioConnectionFromJson(json);
}

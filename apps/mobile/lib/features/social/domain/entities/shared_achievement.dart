import 'package:equatable/equatable.dart';

enum AchievementType {
  streak,
  milestone,
  completion,
  levelUp,
  custom;

  String get displayName {
    switch (this) {
      case AchievementType.streak:
        return 'Streak';
      case AchievementType.milestone:
        return 'Milestone';
      case AchievementType.completion:
        return 'Completion';
      case AchievementType.levelUp:
        return 'Level Up';
      case AchievementType.custom:
        return 'Custom';
    }
  }

  String get emoji {
    switch (this) {
      case AchievementType.streak:
        return '🔥';
      case AchievementType.milestone:
        return '🎉';
      case AchievementType.completion:
        return '✅';
      case AchievementType.levelUp:
        return '⬆️';
      case AchievementType.custom:
        return '⭐';
    }
  }
}

class AchievementData extends Equatable {
  final int? value;
  final String? unit;
  final String? icon;
  final String? color;
  final String? image;

  const AchievementData({
    this.value,
    this.unit,
    this.icon,
    this.color,
    this.image,
  });

  factory AchievementData.fromJson(Map<String, dynamic> json) {
    return AchievementData(
      value: json['value'] as int?,
      unit: json['unit'] as String?,
      icon: json['icon'] as String?,
      color: json['color'] as String?,
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (value != null) 'value': value,
      if (unit != null) 'unit': unit,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (image != null) 'image': image,
    };
  }

  @override
  List<Object?> get props => [value, unit, icon, color, image];
}

class SharedAchievement extends Equatable {
  final String id;
  final String userId;
  final AchievementType type;
  final String title;
  final String description;
  final AchievementData data;
  final String shareUrl;
  final String? imageUrl;
  final int shareCount;
  final int viewCount;
  final DateTime createdAt;

  const SharedAchievement({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.description,
    this.data = const AchievementData(),
    required this.shareUrl,
    this.imageUrl,
    this.shareCount = 0,
    this.viewCount = 0,
    required this.createdAt,
  });

  SharedAchievement copyWith({
    String? id,
    String? userId,
    AchievementType? type,
    String? title,
    String? description,
    AchievementData? data,
    String? shareUrl,
    String? imageUrl,
    int? shareCount,
    int? viewCount,
    DateTime? createdAt,
  }) {
    return SharedAchievement(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      data: data ?? this.data,
      shareUrl: shareUrl ?? this.shareUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      shareCount: shareCount ?? this.shareCount,
      viewCount: viewCount ?? this.viewCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory SharedAchievement.fromJson(Map<String, dynamic> json) {
    return SharedAchievement(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: AchievementType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => AchievementType.custom,
      ),
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      data: json['data'] != null
          ? AchievementData.fromJson(json['data'] as Map<String, dynamic>)
          : const AchievementData(),
      shareUrl: json['share_url'] as String,
      imageUrl: json['image_url'] as String?,
      shareCount: json['share_count'] as int? ?? 0,
      viewCount: json['view_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type.name,
      'title': title,
      'description': description,
      'data': data.toJson(),
      'share_url': shareUrl,
      'image_url': imageUrl,
      'share_count': shareCount,
      'view_count': viewCount,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        title,
        description,
        data,
        shareUrl,
        imageUrl,
        shareCount,
        viewCount,
        createdAt,
      ];
}

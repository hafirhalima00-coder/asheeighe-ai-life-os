import 'package:equatable/equatable.dart';

enum TemplateCategory {
  study,
  business,
  wellness,
  islamic,
  personal,
  productivity;

  String get displayName {
    switch (this) {
      case TemplateCategory.study:
        return 'Study';
      case TemplateCategory.business:
        return 'Business';
      case TemplateCategory.wellness:
        return 'Wellness';
      case TemplateCategory.islamic:
        return 'Islamic';
      case TemplateCategory.personal:
        return 'Personal';
      case TemplateCategory.productivity:
        return 'Productivity';
    }
  }

  String get icon {
    switch (this) {
      case TemplateCategory.study:
        return '📚';
      case TemplateCategory.business:
        return '💼';
      case TemplateCategory.wellness:
        return '🧘';
      case TemplateCategory.islamic:
        return '🕌';
      case TemplateCategory.personal:
        return '🎯';
      case TemplateCategory.productivity:
        return '⚡';
    }
  }
}

class Template extends Equatable {
  final String id;
  final String name;
  final String description;
  final TemplateCategory category;
  final String authorId;
  final String authorName;
  final int usageCount;
  final double rating;
  final int ratingCount;
  final bool isProOnly;
  final String? previewImage;
  final Map<String, dynamic> data;
  final List<String> tags;
  final DateTime createdAt;

  const Template({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.authorId,
    required this.authorName,
    this.usageCount = 0,
    this.rating = 0.0,
    this.ratingCount = 0,
    this.isProOnly = false,
    this.previewImage,
    this.data = const {},
    this.tags = const [],
    required this.createdAt,
  });

  Template copyWith({
    String? id,
    String? name,
    String? description,
    TemplateCategory? category,
    String? authorId,
    String? authorName,
    int? usageCount,
    double? rating,
    int? ratingCount,
    bool? isProOnly,
    String? previewImage,
    Map<String, dynamic>? data,
    List<String>? tags,
    DateTime? createdAt,
  }) {
    return Template(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      usageCount: usageCount ?? this.usageCount,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      isProOnly: isProOnly ?? this.isProOnly,
      previewImage: previewImage ?? this.previewImage,
      data: data ?? this.data,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Template.fromJson(Map<String, dynamic> json) {
    return Template(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      category: TemplateCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => TemplateCategory.personal,
      ),
      authorId: json['author_id'] as String? ?? '',
      authorName: json['author_name'] as String? ?? 'Unknown',
      usageCount: json['usage_count'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      ratingCount: json['rating_count'] as int? ?? 0,
      isProOnly: json['is_pro_only'] as bool? ?? false,
      previewImage: json['preview_image'] as String?,
      data: json['data'] as Map<String, dynamic>? ?? {},
      tags: List<String>.from(json['tags'] ?? []),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category.name,
      'author_id': authorId,
      'author_name': authorName,
      'usage_count': usageCount,
      'rating': rating,
      'rating_count': ratingCount,
      'is_pro_only': isProOnly,
      'preview_image': previewImage,
      'data': data,
      'tags': tags,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String get formattedUsageCount {
    if (usageCount >= 1000000) {
      return '${(usageCount / 1000000).toStringAsFixed(1)}M';
    } else if (usageCount >= 1000) {
      return '${(usageCount / 1000).toStringAsFixed(1)}K';
    }
    return usageCount.toString();
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        category,
        authorId,
        authorName,
        usageCount,
        rating,
        ratingCount,
        isProOnly,
        previewImage,
        data,
        tags,
        createdAt,
      ];
}

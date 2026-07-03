import '../../domain/entities/template.dart';

class TemplateModel extends Template {
  const TemplateModel({
    required super.id,
    required super.name,
    required super.description,
    required super.category,
    required super.authorId,
    required super.authorName,
    super.usageCount,
    super.rating,
    super.ratingCount,
    super.isProOnly,
    super.previewImage,
    super.data,
    super.tags,
    required super.createdAt,
  });

  factory TemplateModel.fromJson(Map<String, dynamic> json) {
    return TemplateModel(
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

  @override
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

  TemplateModel copyWith({
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
    return TemplateModel(
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
}

import 'package:equatable/equatable.dart';

enum BadgeRarity { common, rare, epic, legendary }

enum BadgeCategory {
  coding,
  spiritual,
  productivity,
  social,
  streak,
  milestone,
}

class Badge extends Equatable {
  final String id;
  final String name;
  final String description;
  final String icon;
  final BadgeCategory category;
  final BadgeRarity rarity;
  final DateTime? earnedAt;
  final bool isUnlocked;

  const Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.category,
    required this.rarity,
    this.earnedAt,
    this.isUnlocked = false,
  });

  Badge copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    BadgeCategory? category,
    BadgeRarity? rarity,
    DateTime? earnedAt,
    bool clearEarnedAt = false,
    bool? isUnlocked,
  }) {
    return Badge(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      rarity: rarity ?? this.rarity,
      earnedAt: clearEarnedAt ? null : (earnedAt ?? this.earnedAt),
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  Color get rarityColor {
    switch (rarity) {
      case BadgeRarity.common:
        return const Color(0xFF9E9E9E);
      case BadgeRarity.rare:
        return const Color(0xFF2196F3);
      case BadgeRarity.epic:
        return const Color(0xFF9C27B0);
      case BadgeRarity.legendary:
        return const Color(0xFFFFD700);
    }
  }

  String get rarityLabel {
    switch (rarity) {
      case BadgeRarity.common:
        return 'Common';
      case BadgeRarity.rare:
        return 'Rare';
      case BadgeRarity.epic:
        return 'Epic';
      case BadgeRarity.legendary:
        return 'Legendary';
    }
  }

  @override
  List<Object?> get props => [id, name, description, icon, category, rarity, earnedAt, isUnlocked];
}

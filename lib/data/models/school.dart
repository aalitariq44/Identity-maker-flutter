class School {
  final int? id;
  final String nameArabic;
  final String nameEnglish;
  final String address;
  final String phone;
  final String principal;
  final String? logoPath;
  final DateTime createdAt;
  final DateTime updatedAt;

  const School({
    this.id,
    required this.nameArabic,
    required this.nameEnglish,
    required this.address,
    required this.phone,
    required this.principal,
    this.logoPath,
    required this.createdAt,
    required this.updatedAt,
  });

  factory School.fromMap(Map<String, dynamic> map) {
    return School(
      id: map['id'] as int?,
      nameArabic: map['name_arabic'] as String,
      nameEnglish: map['name_english'] as String,
      address: map['address'] as String,
      phone: map['phone'] as String,
      principal: map['principal'] as String,
      logoPath: map['logo_path'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name_arabic': nameArabic,
      'name_english': nameEnglish,
      'address': address,
      'phone': phone,
      'principal': principal,
      'logo_path': logoPath,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  School copyWith({
    int? id,
    String? nameArabic,
    String? nameEnglish,
    String? address,
    String? phone,
    String? principal,
    String? logoPath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return School(
      id: id ?? this.id,
      nameArabic: nameArabic ?? this.nameArabic,
      nameEnglish: nameEnglish ?? this.nameEnglish,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      principal: principal ?? this.principal,
      logoPath: logoPath ?? this.logoPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is School &&
        other.id == id &&
        other.nameArabic == nameArabic &&
        other.nameEnglish == nameEnglish &&
        other.address == address &&
        other.phone == phone &&
        other.principal == principal &&
        other.logoPath == logoPath;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      nameArabic,
      nameEnglish,
      address,
      phone,
      principal,
      logoPath,
    );
  }

  @override
  String toString() {
    return 'School(id: $id, nameArabic: $nameArabic, nameEnglish: $nameEnglish)';
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String? token;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.token,
  });

  // JSON'dan User objesi oluştur
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      photoUrl: json['photoUrl'],
      token: json['token'],
    );
  }

  // User objesini JSON'a çevir
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'token': token,
    };
  }

  // User objesini kopyala (bazı alanları güncelleyerek)
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      token: token ?? this.token,
    );
  }

  // İsim ve soyisimden ilk harfleri al (avatar için)
  String get initials {
    final nameParts = name.trim().split(' ');
    if (nameParts.isEmpty) return '?';
    if (nameParts.length == 1) {
      return nameParts[0].isNotEmpty ? nameParts[0][0].toUpperCase() : '?';
    }
    return '${nameParts[0][0]}${nameParts[nameParts.length - 1][0]}'.toUpperCase();
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, photoUrl: $photoUrl)';
  }
}

class User {
  final String id;
  final String account;
  final String role;
  final String name;
  final String email;
  final String? img;
  final bool isAlert;
  final String content;

  User({
    required this.id,
    required this.account,
    required this.role,
    required this.name,
    required this.email,
    this.img,
    required this.isAlert,
    required this.content,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      account: json['account'] ?? '',
      role: json['role'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      img: json['img'],
      isAlert: json['is_alert'] ?? false,
      content: json['content'] ?? '',
    );
  }

  factory User.empty() {
    return User(
      id: '',
      account: '',
      role: '',
      name: '',
      email: '',
      img: null,
      isAlert: false,
      content: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'account': account,
      'role': role,
      'name': name,
      'email': email,
      'img': img,
      'is_alert': isAlert,
      'content': content,
    };
  }
}

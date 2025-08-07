class Notifications {
  final int id;
  final String sender;
  final String receiver;
  final int board;
  final int boardTypes;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isRead;
  final bool isDelete;
  final String name; // JOIN users 로 가져온 사용자 이름

  Notifications({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.board,
    required this.boardTypes,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.isRead,
    required this.isDelete,
    required this.name,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      id: json['id'],
      sender: json['sender'],
      receiver: json['receiver'],
      board: json['board'],
      boardTypes: json['board_types'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      isRead: json['is_read'],
      isDelete: json['is_delete'],
      name: json['name'] ?? '',
    );
  }

  Notifications copyWith({
    bool? isRead,
  }) {
    return Notifications(
      id: id,
      sender: sender,
      receiver: receiver,
      board: board,
      boardTypes: boardTypes,
      content: content,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isRead: isRead ?? this.isRead,
      isDelete: isDelete,
      name: name,
    );
  }
}

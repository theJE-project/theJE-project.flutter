class Notifications {
  final int id;
  final String sender;
  final String receiver;
  final int board;
  final int boardTypes;
  final String? content;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isRead;
  final bool isDelete;
  final String name; // JOIN users로 가져온 사용자 이름

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
      id: json['id'] as int,
      sender: json['sender'] as String,
      receiver: json['receiver'] as String,
      board: json['board'] as int,
      boardTypes: json['board_types'] as int,
      content: json['content'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
      isRead: json['is_read'] as bool,
      isDelete: json['is_delete'] as bool,
      name: (json['name'] as String?) ?? '',
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

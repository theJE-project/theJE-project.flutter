class NotificationsDto {
  final int? id;
  final String? sender;
  final String? receiver;
  final int? board;
  final int? boardTypes;
  final String? content;
  final DateTime? createdAt;
  final bool? isRead;
  final bool? isDelete;

  NotificationsDto({
    this.id,
    this.sender,
    this.receiver,
    this.board,
    this.boardTypes,
    this.content,
    this.createdAt,
    this.isRead,
    this.isDelete,
  });

  // JSON 데이터를 Dart 객체로 변환하는 factory 생성자
  factory NotificationsDto.fromJson(Map<String, dynamic> json) {
    return NotificationsDto(
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      sender: json['sender'] as String?,
      receiver: json['receiver'] as String?,
      board: json['board'] != null ? (json['board'] as num).toInt() : null,
      boardTypes: json['board_types'] != null ? (json['board_types'] as num).toInt() : null,
      content: json['content'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      isRead: json['is_read'] as bool?,
      isDelete: json['is_delete'] as bool?,
    );
  }

  // Dart 객체를 JSON 데이터로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender,
      'receiver': receiver,
      'board': board,
      'board_types': boardTypes,
      'content': content,
      'created_at': createdAt?.toIso8601String(),
      'is_read': isRead,
      'is_delete': isDelete,
    };
  }

  @override
  String toString() {
    return 'NotificationsDto(id: $id, sender: $sender, receiver: $receiver, board: $board, boardTypes: $boardTypes, content: $content, createdAt: $createdAt, isRead: $isRead, isDelete: $isDelete)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationsDto &&
        other.id == id &&
        other.sender == sender &&
        other.receiver == receiver &&
        other.board == board &&
        other.boardTypes == boardTypes &&
        other.content == content &&
        other.createdAt == createdAt &&
        other.isRead == isRead &&
        other.isDelete == isDelete;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      sender.hashCode ^
      receiver.hashCode ^
      board.hashCode ^
      boardTypes.hashCode ^
      content.hashCode ^
      createdAt.hashCode ^
      isRead.hashCode ^
      isDelete.hashCode;
}
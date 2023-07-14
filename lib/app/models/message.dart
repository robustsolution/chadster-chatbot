// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AiMessage {
  String role;
  String content;
  String? name;

  AiMessage({
    required this.role,
    required this.content,
    this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'role': role,
      'content': content,
      'name': name,
    };
  }

  factory AiMessage.fromMap(Map<String, dynamic> map) {
    return AiMessage(
      role: map['role'] as String,
      content: map['content'] as String,
      name: map['name'] != null ? map['name'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AiMessage.fromJson(String source) =>
      AiMessage.fromMap(json.decode(source) as Map<String, dynamic>);
}

import 'package:acc/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatDetails extends ConsumerStatefulWidget {
  final ChatModel chat;
  const ChatDetails({super.key, required this.chat});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatDetailsState();
}

class _ChatDetailsState extends ConsumerState<ChatDetails> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

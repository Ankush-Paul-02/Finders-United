import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  final String receiverPhoneNumber;
  final String receiverImageUrl;

  const ChatScreen({
    super.key,
    required this.receiverId,
    required this.receiverName,
    required this.receiverPhoneNumber,
    required this.receiverImageUrl,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void sendMessage(
    ChatProvider chatProvider,
    String receiverId,
    String message,
  ) async {
    if (message.trim().isNotEmpty) {
      await chatProvider.sendMessage(receiverId, message);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: true);
    final authProvider = Provider.of<AuthProvider>(context);

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 7.h),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Row(
              children: [
                CircleAvatar(
                  radius: 3.h,
                  backgroundImage: NetworkImage(widget.receiverImageUrl),
                ),
                3.w.widthBox,
                widget.receiverName.text.make(),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: _buildMessageList(chatProvider, authProvider),
            ),
            _buildMessageInput(chatProvider),
          ],
        ).pSymmetric(h: 5.w, v: 5.w),
      ),
    );
  }

  Widget _buildMessageList(
    ChatProvider chatProvider,
    AuthProvider authProvider,
  ) {
    return StreamBuilder(
      stream: chatProvider.getMessages(
        widget.receiverId,
        authProvider.user.uid,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.cyan),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No messages yet.'),
          );
        } else {
          return ListView(
            children: snapshot.data!.docs
                .map(
                  (document) => _buildMessageItem(
                    document,
                    authProvider,
                  ),
                )
                .toList(),
          );
        }
      },
    );
  }

  Widget _buildMessageInput(ChatProvider chatProvider) {
    return Row(
      children: [
        Expanded(
          child: VxTextField(
            controller: _messageController,
            hint: 'Enter message...',
          ),
        ),
        IconButton(
          onPressed: () {
            sendMessage(
                chatProvider, widget.receiverId, _messageController.text);
          },
          icon: const Icon(Icons.send),
        ),
      ],
    );
  }

  Widget _buildMessageItem(
    DocumentSnapshot document,
    AuthProvider authProvider,
  ) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var alignment = (data['senderId'] == authProvider.user.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data['senderPhoneNumber']),
          Text(data['message']),
        ],
      ),
    );
  }
}

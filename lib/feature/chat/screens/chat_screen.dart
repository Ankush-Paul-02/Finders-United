import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../core/common/custom_send_message_text_field.dart';
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
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 7.h),
          child: AppBar(
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            title: Row(
              children: [
                CircleAvatar(
                  radius: 3.h,
                  backgroundImage: NetworkImage(widget.receiverImageUrl),
                ),
                3.w.widthBox,
                widget.receiverName.text.black.make(),
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
          child: CustomSendMessageTextField(
            controller: _messageController,
            hintText: 'Write your queries...',
            maxLines: 1,
            textInputType: TextInputType.text,
          ),
        ),
        IconButton(
          onPressed: () {
            sendMessage(
              chatProvider,
              widget.receiverId,
              _messageController.text.trim(),
            );
          },
          icon: Container(
            padding: EdgeInsets.all(3.w),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.cyan,
            ),
            child: const Icon(
              Icons.send,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageItem(
    DocumentSnapshot document,
    AuthProvider authProvider,
  ) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    final alignment = (data['senderId'] == authProvider.user.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    final isSender = (data['senderId'] == authProvider.user.uid) ? true : false;
    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 5.w),
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.h),
            decoration: BoxDecoration(
              color: isSender ? Colors.cyan : Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: isSender ? Colors.cyan.shade100 : Colors.grey.shade100,
                  offset: const Offset(1, 2),
                  spreadRadius: 1,
                  blurRadius: 1,
                ),
              ],
            ),
            child: Text(
              data['message'],
              style: TextStyle(
                fontSize: 16,
                color: isSender ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//C:\Users\user\Desktop\0703flutter_v2\lib\features\chatbot\view\chatbot_screen.dart
import 'package:flutter/material.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [
    {'sender': 'chatbot', 'text': '안녕하세요! 어떤 치아 고민이 있으신가요?'},
    {'sender': 'user', 'text': '어금니가 시려요.'},
    {'sender': 'chatbot', 'text': '시린 치아는 잇몸 질환이나 충치일 수 있어요. 더 자세히 말씀해주시겠어요?'},
  ]; // 챗봇 대화 목록 (임시 데이터)

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add({'sender': 'user', 'text': _messageController.text});
      });
      // TODO: 여기에 챗봇 API 호출 로직 추가 (ViewModel 연동)
      // 예시: _messages.add({'sender': 'chatbot', 'text': '챗봇 응답'});
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '치아 챗봇',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent, // 앱바 색상 변경
        elevation: 4, // 그림자 효과
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['sender'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue[100] : Colors.grey[200], // 메시지 배경색
                      borderRadius: BorderRadius.circular(15.0), // 둥근 모서리
                      boxShadow: [ // 그림자 추가
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75, // 메시지 최대 너비 제한
                    ),
                    child: Text(
                      message['text']!,
                      style: TextStyle(
                        color: isUser ? Colors.blue[900] : Colors.grey[800],
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: '메시지를 입력하세요...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0), // 둥근 입력창
                        borderSide: BorderSide.none, // 테두리 없음
                      ),
                      filled: true,
                      fillColor: Colors.grey[100], // 입력창 배경색
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    ),
                    onSubmitted: (value) => _sendMessage(), // 엔터 키로 전송
                  ),
                ),
                const SizedBox(width: 8.0),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  backgroundColor: Colors.blueAccent, // 전송 버튼 색상
                  elevation: 2,
                  shape: const CircleBorder(), // 동그란 버튼
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
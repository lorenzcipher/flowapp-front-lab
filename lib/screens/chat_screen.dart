import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Chatbot',
      theme: ThemeData.dark(),
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = []; // {'role': 'user'/'bot', 'text': '...'}
  bool _isBotTyping = false;

  // Replace with your Azure OpenAI API key and endpoint
  final String apiKey = 'GIBcbSjTManHm5nsy5R1NwSkMIeMZVYLwPk9RciohobZKhTpRa5DJQQJ99BDAC5T7U2XJ3w3AAABACOG3Yga';
  final String endpoint = 'https://virtualassis.openai.azure.com/';
  final String deployment = 'gpt-4'; // Use the correct deployment name for your Azure model

  Future<String> _generateBotResponse(String userMessage) async {
    final response = await http.post(
      Uri.parse('$endpoint/openai/deployments/$deployment/chat/completions?api-version=2025-01-01-preview'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: json.encode({
        'model': deployment, // Azure model name
        'messages': [
          {'role': 'user', 'content': userMessage},
        ],
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final botMessage = responseData['choices'][0]['message']['content'];
      return botMessage;
    } else {
      return "Error: Unable to get response from Azure OpenAI API.";
    }
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _isBotTyping = true;
    });

    _controller.clear();

    // Call the OpenAI API asynchronously
    _getBotResponse(text);
  }

  Future<void> _getBotResponse(String userMessage) async {
    final botResponse = await _generateBotResponse(userMessage);

    setState(() {
      _messages.add({'role': 'bot', 'text': botResponse});
      _isBotTyping = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      appBar: AppBar(
        title: Text("AI Bot"),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                final isUser = message['role'] == 'user';

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blueAccent : Colors.grey[800],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      message['text'] ?? '',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.white),
                  onPressed: _sendMessage,
                )
              ],
            ),
          ),
          if (_isBotTyping)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Bot is typing...",
                style: TextStyle(color: Colors.grey),
              ),
            )
        ],
      ),
    );
  }
}

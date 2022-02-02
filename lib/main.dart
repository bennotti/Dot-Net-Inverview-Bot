import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:math';
import 'DotNetQuestions.dart';
import 'src/chat_view.dart';
import 'src/models/chat_message.dart';
import 'src/models/chat_user.dart';
import 'src/models/quick_replies.dart';
import 'src/models/reply.dart';

String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dot Net Interview Bot',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ChatMessage> _messages = [];

  final _user = ChatUser(
    name: "Self",
    uid: "06c33e8b-e835-4736-80f4-63f44b66666c",
    avatar:
        "https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png",
  );
  final _user2 = ChatUser(
    name: "Bot .Net",
    uid: "06c33e8b-e835-4736-80f4-63f44b66666d",
  );
  Dotnetquestions ques = Dotnetquestions();
  void initState() {
    _addMessage(ChatMessage(
      user: _user2,
      createdAt: DateTime.now(),
      id: randomString(),
      text:
          "Hi! Enter any keyword of a dotnet interview questions like 'interface', 'abstract', 'CLR' etc",
    ));
  }

  void _addMessage(ChatMessage message) {
    setState(() {
      _messages.add(message);
    });
  }

  void _handleSendPressed(ChatMessage message) {
    final textMessage = ChatMessage(
      user: _user,
      createdAt: DateTime.now(),
      id: randomString(),
      text: message.text,
    );
    _addMessage(textMessage);
    var questionAndAnswers =
        ques.getQuestionAnswers(message.text!.toUpperCase());
    List<Reply> replies = <Reply>[];
    questionAndAnswers
        .forEach((k, v) => {replies.add(Reply(title: k, value: k))});
    if(replies.length > 0){
      _addMessage(ChatMessage(
          user: _user2,
          createdAt: DateTime.now(),
          id: randomString(),
          text: "Please select any of the questions",
          quickReplies:QuickReplies(values: replies)));
    }
    else
      {
        _addMessage(ChatMessage(
            user: _user2,
            createdAt: DateTime.now(),
            id: randomString(),
            text: "No Question found with this keyword. Can you please try to enter different keyword",
            ));
      }

  }

  void _onMessageTap(ChatMessage p1) {
    int count = 1;
    var questionAndAnswers =
        ques.getQuestionAnswers(p1.toJson()['text'].toUpperCase());
    questionAndAnswers.forEach((k, v) => {
          if (count == 1)
            {
              _addMessage(ChatMessage(
                user: _user,
                createdAt: DateTime.now(),
                id: randomString(),
                text: k,
              ))
            },
          _addMessage(ChatMessage(
            user: _user2,
            createdAt: DateTime.now(),
            id: randomString(),
            text: v.toString(),
          )),
          count++,
        });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: DashChat(
          messages: _messages,
          user: _user,
          onSend: _handleSendPressed,
          sendOnEnter: true,
          quickReplyScroll: true,
          onQuickReply: onQuickReply,
          showInputCursor: true,
          inputDecoration: const InputDecoration(
            hintText: 'Enter any of the dot net',
            border: OutlineInputBorder(),
          ),
          showAvatarForEveryMessage: false,
        ),
      ),
    );
  }

  onQuickReply(Reply p1) {
    _onMessageTap(ChatMessage(
      user: _user,
      createdAt: DateTime.now(),
      id: randomString(),
      text: p1.value,
    ));
  }
}

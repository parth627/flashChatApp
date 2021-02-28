import 'package:flash_chat/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id='chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController=TextEditingController();
  final _auth= FirebaseAuth.instance;
  String messagetext;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser()async {
    try{
      final user = await _auth.currentUser();
      if(user!=null){
          loggedInUser=user;
      }
    }catch(e){
      print(e);
    }
  }
  // // void getMessages() async {
  // //   final messages= await _firestore.collection('messages').getDocuments();
  // //   for(var message in messages.documents){
  // //     print(message.data);
  // //   }
  // // }
  // void messagesStream()async{
  //   await for(var snapshot in _firestore.collection('messages').snapshots()){
  //     for(var message in snapshot.documents){
  //       print(message.data);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pushNamed(context, LoginScreen.id);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messagetext=value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();
                    _firestore.collection('messages').add({
                      'sender':loggedInUser.email,
                      'text':messagetext,

                    });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('messages').snapshots(),
        builder: (context,snapshot){
          if(!snapshot.hasData){
            return Center(
              child:CircularProgressIndicator(
                backgroundColor:Colors.lightBlueAccent,
              ),
            );
          }
          final messages=snapshot.data.documents.reversed;
          List<MessageBubble>messageBubbles=[];
          for(var message in messages){
            final messageText=message.data['text'];
            final messageSender=message.data['sender'];
            final currentUser=loggedInUser.email;
            //if(currentUser==messageSender) {}// sender is the logged in one.

            final messageBubble=MessageBubble(sender:messageSender,text:messageText,isMe: currentUser==messageSender,);
            messageBubbles.add(messageBubble);
          }
          return Expanded(
            child: ListView(
              reverse:true,
              padding: EdgeInsets.symmetric(horizontal: 10.0,vertical:20.0),
              children: messageBubbles,
            ),
          );
        }
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender,this.text,this.isMe});
  final String sender;
  final String text;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text(sender,style:TextStyle(fontSize: 12.0,color:Colors.lightBlueAccent)),
          Material(
            borderRadius: isMe?BorderRadius.only(topLeft:Radius.circular(30),bottomLeft: Radius.circular(30),bottomRight:Radius.circular(30))
                :BorderRadius.only(bottomLeft:Radius.circular(30),topRight: Radius.circular(30),bottomRight:Radius.circular(30)),
            elevation: 5.0,
            color:isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding:EdgeInsets.symmetric(vertical:10,horizontal: 20),
              child: Text('$text',
                  style:TextStyle(
                      color:isMe ? Colors.white : Colors.black54,
                      fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:chatapp_firebase/pages/group_info.dart';
import 'package:chatapp_firebase/service/database_service.dart';
import 'package:chatapp_firebase/widgets/message_tile.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;

  const ChatPage({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.userName,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  String admin = "";

  //edit here
  List<Map> myChecklist = [
    {"name": "--PROCEDURE--", "isChecked": false},
    {"name": "Epidermal Cyst Excision", "isChecked": false},
    {"name": "Pilar cyst Excision", "isChecked": false},
    {"name": "Lipoma Excision", "isChecked": false},
    {"name": "--SITE--", "isChecked": false},
    {"name": "Scalp", "isChecked": false},
    {"name": "Chest/Abdomen", "isChecked": false},
    {"name": "Back", "isChecked": false},
    {"name": "Upper Extremity", "isChecked": false},
    {"name": "Lower Extremity", "isChecked": false},
    {"name": "--Scalpel--", "isChecked": false},
    {"name": "15-Blade", "isChecked": false},
    {"name": "11-Blade", "isChecked": false},
    {"name": "10-Blade", "isChecked": false},
    {"name": "--Top Suture--", "isChecked": false},
    {"name": "3-0 Prolene (Polypropylene)", "isChecked": false},
    {"name": "4-0 Prolene (Polypropylene)", "isChecked": false},
    {"name": "5-0 Prolene (Polypropylene)", "isChecked": false},
    {"name": "5-0 Fast Gut", "isChecked": false},
    {"name": "--Deep Suture--", "isChecked": false},
    {"name": "None", "isChecked": false},
    {"name": "3-0 Vicryl (Polyglactin 910)", "isChecked": false},
    {"name": "4-0 Vicryl (Polyglactin 910)", "isChecked": false},
    {"name": "5-0 Vicryl (Polyglactin 910)", "isChecked": false},
    {"name": "3-0 Monocryl (Poliglecaprone 25)", "isChecked": false},
    {"name": "4-0 Monocryl (Poliglecaprone 25)", "isChecked": false},
    {"name": "5-0 Monocryl (Poliglecaprone 25)", "isChecked": false},
    {"name": "--Tools--", "isChecked": false},
    {"name": "Needle Driver", "isChecked": false},
    {"name": "Adson Tissue Forceps", "isChecked": false},
    {"name": "Bishop-Harmon Forceps", "isChecked": false},
    {"name": "Iris Scissors", "isChecked": false},
    {"name": "Wescott/Castroviejo Scissors", "isChecked": false},
    {"name": "Undermining Scissors", "isChecked": false},
    {"name": "Hemostat", "isChecked": false},
    {"name": "Skin Hooks", "isChecked": false},
    {"name": "--Patient Position--", "isChecked": false},
    {"name": "Supine", "isChecked": false},
    {"name": "Prone", "isChecked": false},
    {"name": "Trendelenburg", "isChecked": false},
    {"name": "Reverse Trendelenburg", "isChecked": false},
    {"name": "On left side", "isChecked": false},
    {"name": "On right side ", "isChecked": false},
    {"name": "--Top Stiches--", "isChecked": false},
    {"name": "Simple Interrupted", "isChecked": false},
    {"name": "Simple Running", "isChecked": false},
    {"name": "Horizontal Mattress", "isChecked": false},
    {"name": "Vertical Mattress ", "isChecked": false},
  ];

  String timestamp = "";

  @override
  void initState() {
    getChatandAdmin();
    getChecklist1();
    getTimeStamp();
    super.initState();
  }

  getChatandAdmin() {
    DatabaseService().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val;
      });
    });
  }

  getChecklist1() {
    DatabaseService().getChecklist(widget.groupId).then((val) {
      setState(() {
        myChecklist = val;
      });
    });
  }

  getTimeStamp() {
    DatabaseService().getTimestamp(widget.groupId).then((val) {
      setState(() {
        timestamp = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
        elevation: 0,
        title: Text(
          widget.groupName,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(
                    context,
                    GroupInfo(
                      groupId: widget.groupId,
                      groupName: widget.groupName,
                      adminName: admin,
                      time: timestamp,
                    ));
              },
              icon: const Icon(Icons.info))
        ],
      ),
      body: Stack(
        children: <Widget>[
          checklist(),
          Align(
            alignment: const Alignment(0.5, -0.0245),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Comments/Other Procedures",
                    style: TextStyle(fontSize: 15),
                  ),
                ]),
          ),
          // chat messages here
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              width: MediaQuery.of(context).size.width,
              child: Row(children: [
                Expanded(
                    child: TextFormField(
                  controller: messageController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Send a message...",
                    hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                    border: InputBorder.none,
                  ),
                )),
                const SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: () {
                    sendMessage();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                        child: Icon(
                      Icons.send,
                      color: Colors.white,
                    )),
                  ),
                )
              ]),
            ),
          )
        ],
      ),
    );
  }

  checklist() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 345),
      child: SingleChildScrollView(
        child: Column(children: [
          const Text("Select Procedures", style: TextStyle(fontSize: 15)),
          Column(
              children: myChecklist.map((favorite) {
            return CheckboxListTile(
                activeColor: Theme.of(context).primaryColor,
                checkboxShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                title: Text(favorite['name']),
                value: favorite['isChecked'],
                onChanged: (val) {
                  setState(() {
                    favorite['isChecked'] = val;
                  });
                });
          }).toList()),
          const SizedBox(height: 10),
          const Divider(color: Colors.grey, thickness: 1),
          const SizedBox(height: 10),
          Wrap(
            children: myChecklist.map((favorite) {
              if (favorite['isChecked'] == true) {
                return Card(
                    elevation: 3,
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            favorite['name'],
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                favorite['isChecked'] = !favorite['isChecked'];
                              });
                            },
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ));
              }
              return Container();
            }).toList(),
          ),
          const SizedBox(height: 10),
          GestureDetector(
              onTap: () {
                sendCheckList();
              },
              child: Container(
                  height: 50,
                  width: 375,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text("Submit checklist",
                        style: TextStyle(color: Colors.white, fontSize: 17)),
                  )))
        ]),
      ),
    );
  }

  sendCheckList() {
    DatabaseService().sendChecklist(myChecklist, widget.groupId);
  }

  chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? Align(
                alignment: const Alignment(0.5, 0.7),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 300,
                  ),
                  child: ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return MessageTile(
                          message: snapshot.data.docs[index]['message'],
                          sender: snapshot.data.docs[index]['sender'],
                          sentByMe: widget.userName ==
                              snapshot.data.docs[index]['sender']);
                    },
                  ),
                ),
              )
            : Container();
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }
}

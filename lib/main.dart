import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

void main() {
  runApp(MaterialApp(
      home:  MyApp()
    )
  );
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  getPermission() async{
    var status = await Permission.contacts.status;
    if (status.isGranted){
      print('허락됨');
      var contacts = await ContactsService.getContacts();
      setState(() {
        name = contacts;
      });

      //연락처에 추가
      //var newPerson = Contact();
      //newPerson.givenName='민수';
      //newPerson.familyName='김';
      //await ContactsService.addContact(newPerson);


    }else if(status.isDenied){
      print('거절됨');
      Permission.contacts.request();
    }
  }

  var name =  [];

  addData(inputName , inputNum) {
    var newData = Contact()
      ..givenName=inputName
      ..phones = [Item(label: "phones", value: inputNum.text)];

    setState(() {
      ContactsService.addContact(newData);
      name.add(newData);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            showDialog(context: context, builder: (context){
              return DialogUI(addData : addData);
            });
          },
        ),
        appBar: AppBar(
          title: Text('연락처 '+name.length.toString()+'명'),
          actions: [IconButton(onPressed: (){ getPermission(); }, icon: Icon(Icons.contacts))],
        ),

        bottomNavigationBar: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.phone),
              Icon(Icons.message_rounded),
              Icon(Icons.contact_page)
            ],
          ),
        ),

        body: ListView.builder(
            itemCount: name.length,
            itemBuilder: (c, i){
              return ListTile(
                leading: Icon(Icons.person),
                title: Text(name[i].givenName),
                trailing: ButtonTheme(
                  minWidth: 10,height: 10,
                  child: RaisedButton(
                      child: Text('삭제'),color: Colors.white38,
                      onPressed: (){
                        setState(() {
                          name.remove(name[i]);
                        });
                      }),
                )
              );
            },
        ),
      );
  }
}

class DialogUI extends StatelessWidget {
  DialogUI({Key? key, this.addData }) : super(key: key);
  final addData;
  var inputName = TextEditingController();
  var inputNum = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 350, height: 250,margin: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: double.infinity,
                child: Column(
                  children: [
                    Text('Contact', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),

                    Text('이름'),
                    TextField( controller: inputName,),
                    Text('전화번호'),
                    TextField( controller: inputNum,keyboardType: TextInputType.number,),
                      ],
                    ),
                ),

            Row(
              children: [
                TextButton(
                    child: Text('완료'),
                    onPressed: (){
                      addData(inputName.text , inputNum);
                      Navigator.pop(context);
                    }),
                TextButton(
                    child: Text('취소'),
                    onPressed: (){Navigator.pop(context);}
                    )
              ],
            )
          ],
        ),
      ),
    );
  }
}

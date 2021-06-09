import 'package:flutter/material.dart';
import 'package:rideon_driver/config/constant.dart';
import 'package:rideon_driver/models/profile/documentModel.dart';
import 'package:rideon_driver/models/user/userModel.dart';
import 'package:rideon_driver/screens/login/loginPage.dart';
import 'package:rideon_driver/screens/profile/addFIle.dart';
import 'package:rideon_driver/widget/appButton.dart';

class DocumentProcessScreen extends StatefulWidget {
  final User? user;
  DocumentProcessScreen({ this.user, Key? key}) : super(key: key);
  @override
  _DocumentProcessScreenState createState() =>
      _DocumentProcessScreenState(this.user);
}

class _DocumentProcessScreenState extends State<DocumentProcessScreen> {
  _DocumentProcessScreenState(this._user);
  User? _user;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Import Documents'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, index) {
                  return Opacity(
                    opacity: (10 - index) / 10.toDouble(),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AddFileScreen(documents[index])));
                      },
                      child: Card(
                        color: cardColor,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      documents[index].title,
                                      style: title.copyWith(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    if (documents[index].stage ==
                                        DocumentStage.done)
                                      Text('Completed'),
                                    if (documents[index].stage ==
                                        DocumentStage.redy)
                                      Text('Ready to begin'),
                                    if (documents[index].stage ==
                                        DocumentStage.attention)
                                      Text(
                                        'Needs your attentions',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                  ],
                                ),
                                Icon(Icons.arrow_forward_ios_outlined)
                              ]),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: documents.length,
              ),
              Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: AppButton().appButton(
                  text: "Register",
                  color: Colors.red,
                  onpressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              LoginPage(fromRegistration: true),
                        ));
                  },
                ),
              ),
            ],
          )),
    );
  }
}

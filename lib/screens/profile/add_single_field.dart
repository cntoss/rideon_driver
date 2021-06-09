import 'package:flutter/material.dart';
import 'package:rideon_driver/screens/profile/profileEditScreen.dart';
import 'package:rideon_driver/services/utils/extension.dart';

class AddSingleField extends StatelessWidget {
  final FieldType type;
  AddSingleField(this.type);
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    TextStyle _style = TextStyle(fontSize: 18);
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 8, right: 8),
        child: Column(
          children: [
            type == FieldType.phone
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2.0, vertical: 8),
                        child: Text(
                          'Phone',
                          style: _style,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 2),
                            width: _width / 8,
                            child: Text(
                              '+977',
                              style: _style,
                            ),
                          ),
                          Container(
                            width: _width - _width / 8 - 16,
                            child: TextFormField(
                              controller: _controller,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).unfocus();
                              },
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              validator: (s) {
                                if(s == null) return 'Plese enter valid phone number';
                                return s.isValidPhone()
                                    ? null
                                    : "${s.trim().length > 0 ? s + " is not a" : "Please enter a"} valid phone number.";
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                ),
                                counterText: '',
                                hintText: "Phone Number",
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2.0, vertical: 8),
                        child: Text(
                          'Confirm your email address',
                          style: _style,
                        ),
                      ),
                      TextFormField(
                        controller: _controller,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).unfocus();
                        },
                        validator: (s) {
                          if(s == null) return 'Please enter valid email';
                          return s.isValidEmail()
                              ? null
                              : "${s.trim().length > 0 ? s + " is not a" : "Please enter a"} valid email address.";
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.mail_outline_outlined,
                            color: Colors.grey,
                          ),
                          labelText: "Email",
                          hintText: "Enter valid email",
                        ),
                      )
                    ],
                  ),
            Container(
                padding: EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    onPressed: () {
                      //todo upload code
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Save',
                        style: TextStyle(fontSize: 18),
                      ),
                    ))),
          ],
        ),
      ),
    );
  }
}

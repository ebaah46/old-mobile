import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'dart:async';

class ContactDev extends StatefulWidget {
  @override
  _ContactDevState createState() => _ContactDevState();
}

class _ContactDevState extends State<ContactDev> {
  bool buttonState = false,
      numberState = false,
      nameState = false,
      messageState = false,
      emailState = false;
  var color = Colors.grey;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Map<String, dynamic> contactInfo = {
    'fullName': null,
    'email': null,
    'phone': null,
    'subject': null,
    'message': null
  };

  Future<void> send() async {
    final Email email = Email(
      body: contactInfo['message'],
      subject: contactInfo['subject'],
      recipients: ['ebaah46@yahoo.com'],
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Contact Us", style: TextStyle(fontSize: 20.0)),
        ),
        body: Material(
            child: Form(
          key: formKey,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: ListView(scrollDirection: Axis.vertical, children: <Widget>[
              SizedBox(
                height: 35,
              ),
              _name(),
              _email(),
              _phone(),
              _subject(),
              _message(),
              _sendButton(),
            ]),
          ),
        )));
  }

  Widget _name() {
    return Material(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
        child: TextFormField(
          autovalidate: true,
          validator: (String value) {
            if (value.isEmpty)
              return 'Name cannot be empty';
            else {
              nameState = true;
            }
          },
          maxLength: 50,
          maxLines: 1,
          style: TextStyle(
              fontFamily: "Roboto", fontSize: 15.0, color: Colors.black),
          autofocus: true,
          decoration: InputDecoration(
              labelText: "Full Name",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)))),
          onSaved: (String value) {
            contactInfo['fullName'] = value;
          },
        ),
      ),
    );
  }

  Widget _email() {
    return Material(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
        child: TextFormField(
          autovalidate: true,
          validator: (String value) {
            if (value.isEmpty || EmailValidator.validate(value) != true)
              return 'Enter correct email address';
            else {
              emailState = true;
            }
          },
          keyboardType: TextInputType.emailAddress,
          maxLength: 30,
          maxLines: 1,
          style: TextStyle(
              fontFamily: "Roboto", fontSize: 15.0, color: Colors.black),
          autofocus: true,
          decoration: InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)))),
          onSaved: (String value) {
            contactInfo['email'] = value;
          },
        ),
      ),
    );
  }

  Widget _phone() {
    return Material(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
        child: TextFormField(
          maxLines: 1,
          maxLength: 10,
          keyboardType: TextInputType.number,
          style: TextStyle(
              fontFamily: "Roboto", fontSize: 15.0, color: Colors.black),
          autofocus: true,
          decoration: InputDecoration(
            labelText: "Phone",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
          ),
          onSaved: (String value) {
            contactInfo['phone'] = value;
          },
          autovalidate: true,
          validator: (String value) {
            if (value.isEmpty ||
                !RegExp(r'[0-9]{10}').hasMatch(value) ||
                value.length != 10)
              return 'Enter correct phone number';
            else {
              numberState = true;
            }
          },
        ),
      ),
    );
  }

  Widget _subject() {
    return Material(
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
        child: TextFormField(
          maxLines: 1,
          maxLength: 20,
          keyboardType: TextInputType.text,
          style: TextStyle(
              fontFamily: "Roboto", fontSize: 15.0, color: Colors.black),
          autofocus: true,
          decoration: InputDecoration(
              labelText: "Subject",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)))),
          onSaved: (String value) {
            contactInfo['subject'] = value;
          },
          autovalidate: true,
        ),
      ),
    );
  }

  Widget _message() {
    return Material(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
        child: TextFormField(
          keyboardType: TextInputType.multiline,
          maxLines: 8,
          style: TextStyle(
              fontFamily: "Roboto", fontSize: 15.0, color: Colors.black),
          autofocus: true,
          decoration: InputDecoration(
              labelText: "Message",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)))),
          onSaved: (String value) {
            contactInfo['message'] = value;
          },
          onFieldSubmitted: _changeButtonState(),
          validator: (String value) {
            if (value.isEmpty)
              return 'Message body cannot be empty';
            else {
              messageState = true;
            }
          },
          autovalidate: true,
        ),
      ),
    );
  }

  Widget _sendButton() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 130.0, right: 130, top: 20, bottom: 20),
      child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          elevation: 5.0,
          highlightElevation: 10.0,
          // shape: ,
          textColor: Colors.white,
          disabledColor: color,
          child: Text("Send",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                  fontFamily: "Roboto")),
          color: color,
          splashColor: Colors.amberAccent,
          onPressed: () {
            if (buttonState == false)
              return null;
            else {
              _run();
            }
          }),
    );
  }

  void _run() {
    formKey.currentState.save();
    send();
    print("Email successfully sent to developers");
  }

  _changeButtonState() {
    if (messageState == true &&
        nameState == true &&
        numberState == true &&
        emailState == true) {
      setState(() {
        color = Colors.deepPurple;
        buttonState = true;
      });
      print("All data saved");
    } else {
      color = Colors.grey;
    }
  }
}

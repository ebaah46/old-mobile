import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutWidget extends StatefulWidget {
  AboutWidget({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return AboutWidgetState();
  }
}

class AboutWidgetState extends State<AboutWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 250.0,
                  floating: false,
                  pinned: true,
                  centerTitle: true,
                  flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Text(
                        "About",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      background: Image.network(
                        "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
                        fit: BoxFit.cover,
                      )),
                ),
              ];
            },
            body: Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: Container(
                    child: ListView(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1.0, color: Colors.black38))),
                          child: ListTile(
                            leading: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.call, color: Colors.black),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Contact Emergency Number",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            onTap: navToDialerScreen,
                          ),
                        ),
                        SizedBox(
                          width: 1.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1.0, color: Colors.black38))),
                          child: ListTile(
                            leading: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.add_alert,
                                      color: Colors.black),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Safety Thresholds",
                                      style: TextStyle(
                                        fontSize: 15.0,
                                      )),
                                )
                              ],
                            ),
                            onTap: safetyThresholds,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1.0, color: Colors.black38))),
                          child: ListTile(
                            leading: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.question_answer,
                                      color: Colors.black),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("FAQ",
                                      style: TextStyle(
                                        fontSize: 15.0,
                                      )),
                                )
                              ],
                            ),
                            onTap: faq,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1.0, color: Colors.black38))),
                          child: ListTile(
                            leading: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.contact_mail,
                                      color: Colors.black),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Contact Developers",
                                      style: TextStyle(
                                        fontSize: 15.0,
                                      )),
                                )
                              ],
                            ),
                            onTap: contactDev,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1.0, color: Colors.black38))),
                          child: ListTile(
                            leading: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.payment,
                                    color: Colors.black,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Support Us",
                                      style: TextStyle(
                                        fontSize: 15.0,
                                      )),
                                )
                              ],
                            ),
                            onTap: supportUs,
                          ),
                        ),
                      ],
                    ),
                  ))
                ],
              ),
            )));
  }

  static navToDialerScreen() async {
    const url = 'tel: 193';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not launch $url";
    }
  }

  static safetyThresholds() async {
    const url = 'https://www.osha.gov/SLTC/indoorairquality/schools.html';
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true, enableJavaScript: true);
    } else {
      throw "Cannot open $url";
    }
  }

  static faq() async {
    const url = 'https://www.osha.gov/SLTC/indoorairquality/faqs.html';
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true, enableJavaScript: true);
    } else {
      throw "Cannot open $url";
    }
  }

  contactDev() async {
    const url =
        'mailto:ebaah72@gmail.com?subject=Info about developers&body=nothing';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Cannot open email $url';
    }
  }

  void supportUs() async {
    const url = 'https://expresspay.com';
    if (await canLaunch(url)) {
      await (launch(url));
    } else {
      throw 'Cannot open $url';
    }
  }
}

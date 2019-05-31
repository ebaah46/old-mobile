import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:old/contact.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutWidget extends StatefulWidget {
  AboutWidget({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return AboutWidgetState();
  }
}

class AboutWidgetState extends State<AboutWidget> {
  ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
            scrollDirection: Axis.vertical,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 290.0,
                  floating: true,
                  snap: false,
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
            body: ListView.custom(
              controller: controller,
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              childrenDelegate: SliverChildListDelegate([
                // _space(),
                _dialerChild(),
                _space(),
                _safetyTipsChild(),
                _space(),
                _faqChild(),
                _space(),
                _contactDevsChild(),
                _space()
              ]),
            )));
  }

  Widget _dialerChild() {
    return InkWell(
      onTap: navToDialerScreen,
      splashColor: Colors.amber,
      child: Container(
        width: double.infinity,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(Icons.call, size: 22, color: Colors.black),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('Contact Emergency Number',
                  style: TextStyle(fontSize: 18)),
            )
          ],
        ),
      ),
    );
  }

  Widget _safetyTipsChild() {
    return InkWell(
      onTap: safetyThresholds,
      splashColor: Colors.amber,
      child: Container(
        width: double.infinity,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(Icons.more, size: 22, color: Colors.black),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('Safety Tips', style: TextStyle(fontSize: 18)),
            )
          ],
        ),
      ),
    );
  }

  Widget _faqChild() {
    return InkWell(
      onTap: faq,
      splashColor: Colors.amber,
      child: Container(
        width: double.infinity,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(Icons.question_answer, size: 22, color: Colors.black),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('FAQ', style: TextStyle(fontSize: 18)),
            )
          ],
        ),
      ),
    );
  }

  Widget _contactDevsChild() {
    return InkWell(
      onTap: contactDev,
      splashColor: Colors.amber,
      child: Container(
        width: double.infinity,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(Icons.email, size: 22, color: Colors.black),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('Contact Developers', style: TextStyle(fontSize: 18)),
            )
          ],
        ),
      ),
    );
  }

  Widget _space() {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black38, width: 2))),
    );
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

  contactDev() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ContactDev()));
  }
}

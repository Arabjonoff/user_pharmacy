import 'package:flutter/material.dart';

const String page1 = "Page 1";
const String page2 = "Page 2";
const String page3 = "Page 3";
const String title = "BNB Demo";

class MyApppp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: title,
      home: new MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> _pages;
  Widget _page1;
  Widget _page2;
  Widget _page3;

  int _currentIndex;
  Widget _currentPage;

  @override
  void initState() {
    super.initState();

    _page1 = Page1();
    _page2 = Page2();
    _page3 = Page3();

    _pages = [_page1, _page2, _page3];

    _currentIndex = 0;
    _currentPage = _page1;
  }

  void changeTab(int index) {
    setState(() {
      _currentIndex = index;
      _currentPage = _pages[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: _currentPage,
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) => changeTab(index),
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
                title: Text(page1), icon: Icon(Icons.account_circle)),
            BottomNavigationBarItem(
                title: Text(page2), icon: Icon(Icons.account_circle)),
            BottomNavigationBarItem(
                title: Text(page3), icon: Icon(Icons.account_circle))
          ]),
      drawer: new Drawer(
        child: new Container(
          margin: EdgeInsets.only(top: 20.0),
          child: new Column(
            children: <Widget>[
              navigationItemListTitle(page1, 0),
              navigationItemListTitle(page2, 1),
              navigationItemListTitle(page3, 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget navigationItemListTitle(String title, int index) {
    return new ListTile(
      title: new Text(
        title,
        style: new TextStyle(color: Colors.blue[400], fontSize: 22.0),
      ),
      onTap: () {
        Navigator.pop(context);
        changeTab(index);
      },
    );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 450,
        child: FadeInImage(
          fit: BoxFit.fitHeight,
          image: NetworkImage(
              "https://online.grandpharm.uz/media/sales/77130e2b-70a8-4aea-bf46-7d1f506ec70b.png"),
          placeholder: AssetImage("assets/images/red.png"),

        ),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(page2),
    );
  }
}

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(page3),
    );
  }
}

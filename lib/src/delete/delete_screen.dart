import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy/src/app_theme.dart';

class MyAppDelete extends StatefulWidget {
  @override
  _MyAppDeleteState createState() => _MyAppDeleteState();
}

class _MyAppDeleteState extends State<MyAppDelete> {
  PageController controller = PageController();
  var currentPageValue = 0.0;
  int currentIndex = 0;

  @override
  void initState() {
    controller.addListener(() {
      setState(() {
        currentPageValue = controller.page;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(currentPageValue);
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 250),
              width: double.infinity,
              child: PageView.builder(
                controller: controller,
                itemBuilder: (context, position) {
                  if (position == currentPageValue.floor()) {
                    return Transform(
                      transform: Matrix4.identity()
                        ..rotateX(currentPageValue - position),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          color: position % 2 == 0 ? Colors.blue : Colors.pink,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            "Page 1 $position",
                            style:
                                TextStyle(color: Colors.white, fontSize: 22.0),
                          ),
                        ),
                      ),
                    );
                  } else if (position == currentPageValue.floor() + 1) {
                    return Transform(
                      transform: Matrix4.identity()
                        ..rotateX(currentPageValue - position),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          color: position % 2 == 0 ? Colors.blue : Colors.pink,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            "Page 2 $position",
                            style:
                                TextStyle(color: Colors.white, fontSize: 22.0),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
                itemCount: 10,
              ),
            ),
          ),
          SizedBox(height: 14),
          SizedBox(height: 14),
        ],
      ),
    );
  }
}

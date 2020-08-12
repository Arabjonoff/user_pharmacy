import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/src/app_theme.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RatingDialog extends StatefulWidget {
  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int _stars = 0;
  TextEditingController commentController = TextEditingController();

  Widget _buildStar(int starCount) {
    return InkWell(
      child: Icon(
        _stars >= starCount ? Icons.star : Icons.star_border,
        color: _stars >= starCount
            ? Colors.orangeAccent
            : AppTheme.black_transparent_text,
      ),
      onTap: () {
        setState(() {
          _stars = starCount;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          translate("auto_update.rate"),
          style: TextStyle(
            fontFamily: AppTheme.fontRoboto,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontStyle: FontStyle.normal,
            color: AppTheme.black_text,
          ),
        ),
      ),
      content: Container(
        height: 226,
        child: Column(
          children: [
            Container(
              height: 35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildStar(1),
                  _buildStar(2),
                  _buildStar(3),
                  _buildStar(4),
                  _buildStar(5),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 175,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                      color: AppTheme.grey.withOpacity(0.08), width: 1)),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 7,
                style: TextStyle(
                  fontFamily: AppTheme.fontRoboto,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal,
                  color: AppTheme.black_text,
                  fontSize: 16,
                ),
                controller: commentController,
                decoration: InputDecoration(
                  hintText: translate("home.comment"),
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    fontFamily: AppTheme.fontRoboto,
                    color: AppTheme.grey,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      width: 1,
                      color: AppTheme.grey.withOpacity(0.001),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    borderSide: BorderSide(
                      width: 1,
                      color: AppTheme.grey.withOpacity(0.001),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            translate("auto_update.cancel"),
            style: TextStyle(
              fontFamily: AppTheme.fontRoboto,
              fontWeight: FontWeight.bold,
              fontSize: 13,
              fontStyle: FontStyle.normal,
              color: AppTheme.black_text,
            ),
          ),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text(
            translate("auto_update.send"),
            style: TextStyle(
              fontFamily: AppTheme.fontRoboto,
              fontWeight: FontWeight.bold,
              fontSize: 13,
              fontStyle: FontStyle.normal,
              color: AppTheme.black_text,
            ),
          ),
          onPressed: () async {
            if (commentController.text.length > 0 || _stars > 0) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              Repository().fetchSendRating(commentController.text, _stars).then(
                    (value) => {
                      if (value.status == 1)
                        {prefs.setInt('userEnterCount', 100), prefs.commit()}
                    },
                  );
              Navigator.of(context).pop();
            }
          },
        )
      ],
    );
  }
}

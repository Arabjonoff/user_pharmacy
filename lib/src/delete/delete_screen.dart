import 'package:flutter/material.dart';
import 'package:pharmacy/src/app_theme.dart';

class MyAppDelete extends StatefulWidget {
  @override
  _MyAppDeleteState createState() => _MyAppDeleteState();
}

class _MyAppDeleteState extends State<MyAppDelete> {
  double _sliderDiscreteValue = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Column(
        children: [
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                  trackHeight: 3,
                  valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                  activeTrackColor: AppTheme.blue,
                  inactiveTrackColor: AppTheme.gray,
                  overlayColor: AppTheme.blue.withOpacity(0.1),
                  thumbColor: AppTheme.blue),
              child: Slider(
                value: _sliderDiscreteValue,
                min: 0,
                max: 1000000,
                onChanged: (value) {
                  setState(() {
                    _sliderDiscreteValue = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

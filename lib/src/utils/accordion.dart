import 'package:flutter/material.dart';
import 'package:pharmacy/src/app_theme.dart';
import 'package:pharmacy/src/model/api/region_model.dart';
import 'package:pharmacy/src/utils/expanded_section.dart';

class Accordion extends StatefulWidget {
  final String title;
  final List<RegionModel> childs;
  final RegionModel data;
  final Function(RegionModel data) onChoose;

  Accordion({
    this.title,
    this.childs,
    this.data,
    this.onChoose,
  });

  @override
  _AccordionState createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  bool _showContent = false;
  var duration = Duration(milliseconds: 270);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _showContent = !_showContent;
            });
          },
          child: Container(
            margin: EdgeInsets.only(
              left: 12,
              right: 12,
            ),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.only(
              top: 16,
              bottom: 16,
              left: 16,
              right: 16,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontFamily: AppTheme.fontRubik,
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        height: 1.2,
                        color: AppTheme.black_text,
                      ),
                    ),
                  ),
                ),
                Icon(
                  _showContent
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppTheme.gray,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        ExpandedSection(
          child: Container(
            width: double.infinity,
            child: ListView.builder(
              itemCount: widget.childs.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, position) {
                return GestureDetector(
                  onTap: () async {
                    widget.onChoose(widget.childs[position]);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: EdgeInsets.only(
                      top: 1,
                      left: 12,
                      right: 12,
                    ),
                    padding: EdgeInsets.only(
                      top: 16,
                      bottom: 16,
                      left: 24,
                      right: 16,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.childs[position].name,
                            style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.normal,
                              fontFamily: AppTheme.fontRubik,
                              fontSize: 15,
                              color: AppTheme.black_text,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        AnimatedContainer(
                          duration: duration,
                          curve: Curves.easeInOut,
                          height: 16,
                          width: 16,
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: AppTheme.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color:
                                  widget.data.id == widget.childs[position].id
                                      ? AppTheme.blue
                                      : AppTheme.gray,
                            ),
                          ),
                          child: AnimatedContainer(
                            duration: duration,
                            curve: Curves.easeInOut,
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              color:
                                  widget.data.id == widget.childs[position].id
                                      ? AppTheme.blue
                                      : AppTheme.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          expand: _showContent,
        ),
        Container(
          height: 1,
          width: double.infinity,
          color: AppTheme.background,
        )
      ],
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

enum DropCapMode {
  inside,
  upwards,
  left,
}

class MyDropCap extends StatelessWidget {
  final Widget child;
  final double width, height;

  MyDropCap({
    Key key,
    this.child,
    @required this.width,
    @required this.height,
  })  : assert(width != null),
        assert(height != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(child: child, width: width, height: height);
  }
}

class MyDropCapText extends StatelessWidget {
  final String data;
  final DropCapMode mode;
  final TextStyle style, dropCapStyle;
  final TextAlign textAlign;
  final MyDropCap dropCap;
  final EdgeInsets dropCapPadding;
  final Offset indentation;
  int dropCapChars;
  final String title;
  final String gender;
  final classification;

  MyDropCapText(
      this.data, {
        this.gender,
        this.title,
        Key key,
        this.mode = DropCapMode.inside,
        this.style,
        this.classification,
        this.dropCapStyle,
        this.textAlign,
        this.dropCap,
        this.dropCapPadding = EdgeInsets.zero,
        this.indentation = Offset.zero,
        this.dropCapChars = 1,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      color: Colors.black,
      fontSize: 18,
      height: 1,
    ).merge(style);

    if (data == '') return Text(data, style: textStyle);

    double capWidth, capHeight;
    double lineHeight = textStyle.fontSize * textStyle.height;
    double capFontSize = textStyle.fontSize * 5.5;
    CrossAxisAlignment sideCrossAxisAlignment = CrossAxisAlignment.start;

    TextStyle capStyle = TextStyle(
      color: textStyle.color,
      fontSize: capFontSize,
      fontFamily: textStyle.fontFamily,
      fontWeight: textStyle.fontWeight,
      fontStyle: textStyle.fontStyle,
      height: 0.8,
    ).merge(dropCapStyle);

    //if (mode == DropCapMode.baseline) return _buildBaseline(textStyle, capStyle);

    // custom DropCap
    if (dropCap != null) {
      capWidth = dropCap.width;
      capHeight = dropCap.height;
      dropCapChars = 0;
    } else {
      TextPainter capPainter = TextPainter(
        text: TextSpan(text: data.substring(0, dropCapChars), style: capStyle),
        textDirection: TextDirection.ltr,
      );
      capPainter.layout();
      capWidth = capPainter.width;
      capHeight = (capPainter.height * 0.8);
    }

    // compute drop cap padding
    capWidth += dropCapPadding.left + dropCapPadding.right;
    capHeight += dropCapPadding.top + dropCapPadding.bottom;

    int rows = ((capHeight - indentation.dy) / lineHeight).ceil();

    // DROP CAP MODE - UPWARDS
    if (mode == DropCapMode.upwards) {
      rows = 6;
      sideCrossAxisAlignment = CrossAxisAlignment.end;
    }

    TextPainter textPainter = TextPainter(
      text: TextSpan(text: data.substring(1), style: textStyle),
      textDirection: TextDirection.ltr,
    );

    // BUILDER
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      double boundsWidth = constraints.maxWidth - capWidth;
      if (boundsWidth < 1) boundsWidth = 1;

      int charIndexEnd = data.length;

      int startMillis = new DateTime.now().millisecondsSinceEpoch;
      if (rows > 0) {
        textPainter.layout(maxWidth: boundsWidth);
        double yPos = (rows + 1) * lineHeight;
        int charIndex = textPainter.getPositionForOffset(Offset(0, yPos)).offset;
        textPainter.maxLines = rows;
        textPainter.layout(maxWidth: boundsWidth);
        if (textPainter.didExceedMaxLines) charIndexEnd = charIndex;
      } else {
        charIndexEnd = dropCapChars;
      }
      int totMillis = new DateTime.now().millisecondsSinceEpoch - startMillis;

      // DROP CAP MODE - LEFT
      if (mode == DropCapMode.left) charIndexEnd = data.length;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //Text(totMillis.toString() + ' ms'),
          Row(
            crossAxisAlignment: sideCrossAxisAlignment,
            children: <Widget>[
              dropCap != null
                  ? Padding(padding: dropCapPadding, child: dropCap)
                  : Container(
                //color: Color(0x44ff8800),
                width: capWidth,
                height: capHeight,
                padding: dropCapPadding,
                child: RichText(
                  text: TextSpan(text: data.substring(0, dropCapChars), style: capStyle),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 16,
                                ),
                                Text(title, style: TextStyle(fontSize: 24),),

                                Text(gender),
                              ],
                            ),
                            Container(
                              width: 30,
                              height: 30,
                              child: classification,
                            )
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        data.substring(dropCapChars, charIndexEnd),
                        //rows.toString() + data.substring(2, charIndexEnd),
                        style: textStyle,
                        textAlign: textAlign,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              data.substring(charIndexEnd).trim(),
              style: textStyle,
              textAlign: textAlign,
            ),
          ),
        ],
      );
    });
  }

  _buildBaseline(TextStyle textStyle, TextStyle capStyle) {
    return RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.black),
        children: <TextSpan>[
          TextSpan(
            text: data.substring(0, dropCapChars),
            style: capStyle.merge(TextStyle(height: 0)),
          ),
          TextSpan(text: data.substring(dropCapChars), style: textStyle),
        ],
      ),
    );
  }
}

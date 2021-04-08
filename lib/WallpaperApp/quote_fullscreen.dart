import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import 'package:share/share.dart';

class FullScreenQuotePage extends StatelessWidget {

  final RandomColor _randomColor = RandomColor();

  String quote;
  FullScreenQuotePage(this.quote);

  final LinearGradient backgroundGradient = new LinearGradient(
      colors: [new Color(0x10000000), new Color(0x30000000)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: _randomColor.randomColor(
                      colorBrightness: ColorBrightness.light
                    ),
      body: new SizedBox.expand(
        child: new Container(
          decoration: new BoxDecoration(gradient: backgroundGradient),
          child: new Stack(
            children: <Widget>[
              new Align(
                alignment: Alignment.center,
                child: Text(quote, style: TextStyle( fontSize: 22.0, color: _randomColor.randomColor(
                      colorBrightness: ColorBrightness.veryDark
                    ), ), textAlign: TextAlign.center,),
              ),
              new Align(
                alignment: Alignment.topCenter,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new AppBar(
                      elevation: 0.0,
                      backgroundColor: Colors.transparent,
                      leading: new IconButton(
                        icon: new Icon(
                          Icons.arrow_back,
                          color: Colors.redAccent,
                          size: 38.0,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      actions: [IconButton(icon: Icon(Icons.share, size: 36,), onPressed: () => share(context, quote) , )],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void share(BuildContext context,String quotes){
    final RenderBox box = context.findRenderObject();
    final String text  = "${quotes.toString()}";

    Share.share(text, subject: quotes.toString());
  }

}

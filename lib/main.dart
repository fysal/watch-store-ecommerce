import 'package:carousel/styles/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Main() ,
  )
);


class Main extends StatefulWidget {

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> with SingleTickerProviderStateMixin{
  AnimationController _animationController;
  var fadeAnimation;

   initState(){
     _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
     fadeAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(_animationController);
     super.initState();
   }

   playAnimation(){
       _animationController.reset();
       _animationController.forward();

   }

  List<List<String>> watches = [
    ['assets/images/watch.jpg','Hugo Boss','400'],
    ['assets/images/watch-1.jpg','Rolex','300'],
    ['assets/images/watch-2.jpg','Audemars Piguet','150'],
    ['assets/images/watch-3.jpg','Patek Philppe','800'],
    ['assets/images/watch-4.jpg','Blancpain','330.0'],
    ['assets/images/watch-5.jpg','Vacheron Constantin','599'],
  ];

  int currentIndex = 0;

  pageNext(){
    if(currentIndex < watches.length - 1){
      setState(() {
        currentIndex ++;
      });
    }else{
      currentIndex = currentIndex;
    }

  }
  pagePrev(){
    if(currentIndex > 0){
      setState(() {
        currentIndex --;
      });
    }else{
      currentIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    ScreenUtil.init(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          GestureDetector(
            onHorizontalDragEnd:(DragEndDetails details){
              if(details.velocity.pixelsPerSecond.dx > 0){
                   pagePrev();
              }else if(details.velocity.pixelsPerSecond.dx < 0){
                pageNext();
              }
            },
            child: Stack(
              children: <Widget>[
                FutureBuilder(
                  future: playAnimation(),
                  builder: (context, snapshot){
                    return FadeTransition(
                      opacity: fadeAnimation,
                      child: Container(
                        height: screenSize.height * .8,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fitHeight,
                            image: AssetImage(watches[currentIndex][0]),
                          ),

                        ),

                      ),
                    );
                  },

                ),
                Positioned(
                  width: screenSize.width,
                  bottom: ScreenUtil().setHeight(720),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _indicators(),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              height: screenSize.height * .35,
              width: screenSize.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)
                )
              ),
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(watches[currentIndex][1],style: hugeText.copyWith(
                        fontSize: ScreenUtil().setSp(100),
                        height: 0.8,
                      )),
                      SizedBox(height: 10,),
                      Row(
                        children: <Widget>[
                          Text("Price ",style: labelStyle,),
                          Text("${watches[currentIndex][2]} \$",
                            style: priceStyle.copyWith(fontSize: ScreenUtil().setSp(80)),)
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: <Widget>[
                          Icon(Icons.star, color: Colors.amber,),
                          Icon(Icons.star, color: Colors.amber,),
                          Icon(Icons.star, color: Colors.amber,),
                          Icon(Icons.star_half, color: Colors.amber,),
                          SizedBox(width: 10,),
                          Text("(4.2 / 7.0 review)"),
                        ],
                      ),
                      SizedBox(height: 20,),
                     Material(

                       borderRadius: BorderRadius.circular(10),
                       color: Colors.amber,
                       child: GestureDetector(
                         onTap: () =>  showPop(),
                         child: Container(
                           width: screenSize.width,
                           height: ScreenUtil().setHeight(110),
                           child: Align(
                             alignment: Alignment.center,
                               child: Text("Add to Cart", style: btnText,)),
                         ),
                       ),
                     )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
    ));


  }
  _indicator(bool isActive){
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInSine,
      width: isActive ? ScreenUtil().setWidth(120) : ScreenUtil().setWidth(25),
      height: ScreenUtil().setHeight(20),
      
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white,
        borderRadius: isActive ? BorderRadius.circular(5) : BorderRadius.circular(20)
      ),
    );
  }
  List<Widget>_indicators(){
    List<Widget> _indicatorList = [];
    for(int i = 0 ; i < watches.length; i++){
      _indicatorList.add(_indicator(currentIndex == i ? true : false));
    }

    return _indicatorList;
  }


  showPop(){
    return showDialog(context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text("Alert",style: TextStyle(fontSize: 35),)),
          content: Text("You are not logged in",style: TextStyle(fontSize:
          18),),
          actions: <Widget>[
            FlatButton(
              child: Text("Close"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
        );
  }
}

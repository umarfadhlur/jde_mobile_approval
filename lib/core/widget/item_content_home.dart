import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jde_mobile_approval/core/constant/constants.dart';
import 'package:jde_mobile_approval/feature/main_menu/ui/widget/item_home.dart';

class ItemContentHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var crossAxisSpacing = 8;
    var screenWidth = MediaQuery.of(context).size.width;
    var crossAxisCount = 2;
    var width = (screenWidth - ((crossAxisCount - 1) * crossAxisSpacing)) /
        crossAxisCount;
    var cellHeight = 150;
    var aspectRatio = width / cellHeight;
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: ColorCustom.blueColor,
            width: MediaQuery.of(context).size.width - 10,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: GridView(
              shrinkWrap: true,
              physics: new NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: aspectRatio),
              children: [
                itemHomeMain(
                    onTap: () {},
                    txtImg: 'assets/images/expansion.png',
                    txtItem: "Expanse"),
                itemHomeMain(
                    onTap: () {},
                    txtImg: 'assets/images/compensation.png',
                    txtItem: "Advanced"),
              ],
            ),
          ),
          // SizedBox(
          //   height: 15,
          //   child: new Center(
          //     child: new Container(
          //       // margin: new EdgeInsetsDirectional.only(start: 5.0, end: 5.0),
          //       height: 15,
          //       color: Colors.grey[200],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

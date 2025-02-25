import 'package:flutter/material.dart';
import 'package:jde_mobile_approval/core/constant/constants.dart';

Widget headerMenu(
    BuildContext context, String username, String environment, String company) {
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.only(left: 10.0, bottom: 10.0, right: 10),
    decoration: BoxDecoration(
      boxShadow: const [
        BoxShadow(
          color: Colors.grey,
          offset: Offset(
            1.0,
            1.0,
          ),
        ),
      ],
      gradient: LinearGradient(colors: ColorCustom.blueGradient1),
      borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(00), bottomRight: Radius.circular(00)),
    ),
    child: Row(
      children: [
        const CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage('assets/images/profile.png'),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: "Product-Sans",
                    fontSize: 30,
                  ),
                ),
                // Text(
                //   environment,
                //   style: TextStyle(
                //       color: Colors.white,
                //       fontFamily: "Righteous-Reguler",
                //       fontSize: SizeConstant.textContentMin),
                // ),
                // Text(
                //   company,
                //   style: TextStyle(
                //       color: Colors.white,
                //       fontFamily: "Righteous-Reguler",
                //       fontSize: SizeConstant.textContentMin),
                // ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

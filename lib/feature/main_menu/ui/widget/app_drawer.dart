import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:jde_mobile_approval/core/constant/color.dart';
import 'package:jde_mobile_approval/core/constant/shared_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  late String _environment, _company, _username, _address;

  void initState() {
    super.initState();
    SharedPreferences.getInstance().then(
      (prefVal) => {
        setState(
          () {
            _company = prefVal.getString(SharedPref.company) ?? "";
            _username = prefVal.getString(SharedPref.username) ?? "";
            _environment = prefVal.getString(SharedPref.environtment) ?? "";
            // _token = prefVal.getString(SharedPref.token) ?? false;
            _address = prefVal.getString(SharedPref.addressnumber) ?? "";
            print('test $_company, $_username, $_environment, $_address');
            // addressNumberBloc.add(AddressNumberInput(name: 'User ID 1', val: _username, token: _token));
          },
        ),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            color: ColorCustom.blueColor,
            height: 150,
            child: DrawerHeader(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/profile1.jpg'),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Text(
                    '$_username\n$_environment',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(),
            ),
          ),
          ListTile(
            title: Text('Home'),
            leading: Icon(EvaIcons.homeOutline),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Approval'),
            leading: Icon(EvaIcons.inboxOutline),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Alert Notice'),
            leading: Icon(EvaIcons.bellOutline),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Others'),
            leading: const Icon(EvaIcons.moreHorizontalOutline),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}

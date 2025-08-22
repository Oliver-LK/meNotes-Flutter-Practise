

import 'dart:developer' as devtools;

import 'package:flutter/material.dart';
import 'package:me_notes/constants/routes.dart';
import 'package:me_notes/enums/menu_enums.dart';
import 'package:me_notes/services/auth/auth_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          PopupMenuButton <MenuAction>(
            onSelected: (value) async {
              devtools.log(value.toString());

              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout == true) {
                    await AuthService.firebase().logOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute, 
                      (_) => false
                    );
                  }
              }
            },

            itemBuilder: (context) {
              return const [
                PopupMenuItem <MenuAction> (
                  value: MenuAction.logout, 
                  child: Text('Log out'),
                ),
              ];
            },
          )
        ],
      ),
      body: const Text("Testing"),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog(
    context: context, 
    builder: (context) {

      return AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [

          TextButton(onPressed: () {
            Navigator.of(context).pop(false);
          }, child: const Text('Cancel')),

          TextButton(onPressed: () {
            Navigator.of(context).pop(true);
          }, child: const Text('Log Out')),
        ],
      );
    }
  ).then((value) => value ?? false);
}

import 'package:flutter/material.dart';
import 'package:tqnia_chat_app_task/core/routes/routes.dart';
import 'package:tqnia_chat_app_task/core/theming/colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Kcolor.mainbackgroundcolor,
        appBar: AppBar(
          backgroundColor: Kcolor.mainbackgroundcolor,
          actions: [
            Container(
              height: 100,
              child: Row(
//mainAxisAlignment: MainAxisAlignment.start,
                //: CrossAxisAlignment.,
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.chat as IconData?,
                    color: Kcolor.mywhite,
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.conversition);
                    },
                    child: Title(
                      color: Kcolor.mywhite,
                      child: Text(
                        'New chat ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Kcolor.mywhite),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                  ),
                  Icon(
                    Icons.arrow_back_ios_new as IconData?,
                    color: Kcolor.mywhite,
                  ),
                ],
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.white54),
                ),
              ),
            )
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 300,
              //color: Colors.amber,
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(color: Colors.white54),
              )),
            ),
            TextButton.icon(
              style: TextButton.styleFrom(
                  foregroundColor: Colors.white60,
                  textStyle: const TextStyle(fontSize: 16)),
              onPressed: () {},
              icon: const Icon(Icons.delete),
              label: const Text(' clear conversitions'),
            ),
            TextButton.icon(
              style: TextButton.styleFrom(
                  foregroundColor: Colors.white60,
                  textStyle: const TextStyle(fontSize: 16)),
              onPressed: () {},
              icon: const Icon(Icons.person),
              label: const Text(' upgrade to plus '),
            ),
            TextButton.icon(
              style: TextButton.styleFrom(
                  foregroundColor: Colors.white60,
                  textStyle: const TextStyle(fontSize: 16)),
              onPressed: () {},
              icon: const Icon(Icons.light_mode),
              label: const Text(' Light mode'),
            ),
            TextButton.icon(
              style: TextButton.styleFrom(
                  foregroundColor: Colors.white60,
                  textStyle: const TextStyle(fontSize: 16)),
              onPressed: () {},
              icon: const Icon(Icons.update),
              label: const Text(' updates &FAQ'),
            ),
            TextButton.icon(
              style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  textStyle: const TextStyle(fontSize: 16)),
              onPressed: () {},
              icon: const Icon(
                Icons.logout,
              ),
              label: const Text(
                ' Logouts',
              ),
            )
          ],
        ));
  }
}

import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ 
          Image.asset('assets/images/not-removebg-preview 1.png'),
          SizedBox(height: 15,),
          Image(image:AssetImage('assets/images/No Notification Yet.png'))
        ],
      ),
    );
  }
}

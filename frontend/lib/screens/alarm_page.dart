import 'package:flutter/material.dart';
import 'package:frontend/widgets/alarm/alarm_widget.dart';
import 'package:frontend/screens/alarm/alarm_create_page.dart';

class AlarmPage extends StatelessWidget {
  const AlarmPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          title: Text('알람',
              style: TextStyle(
                  color: Colors.black,
                  fontSize:
                      MediaQuery.of(context).size.height >= 720 ? 30 : 16)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          child: Stack(
            children: [
              ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, i) {
                    return CustomAlarmWidget(status: 3);
                  }),
              Positioned(
                bottom: 40,
                right: 40,
                child: FloatingActionButton(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AlarmCreatePage(
                                    isCreate: true,
                                  )));
                    },
                    child: Text('+', style: TextStyle(color: Colors.white))),
              )
            ],
          ),
        ),
      ),
    );
  }
}

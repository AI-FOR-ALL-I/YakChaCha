import 'package:flutter/material.dart';

class TextSearchPillComponent extends StatelessWidget {
  const TextSearchPillComponent({super.key});

  @override
  Widget build(BuildContext context) {
    bool isWarning = true;
    return AspectRatio(
      aspectRatio: 1.2 / 1,
      child: Container(
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.red),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Column(
            children: [
              Flexible(
                flex: 2,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/images/night.png',
                      fit: BoxFit.cover,
                    ),
                    if (isWarning)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Icon(
                          Icons.warning_amber,
                          color: Colors.red,
                        ),
                      ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: 0,
                    maxHeight: double.infinity,
                  ),
                  child: Center(
                    child: Text('약이름'),
                  ),
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

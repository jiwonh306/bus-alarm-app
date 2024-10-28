import 'package:flutter/material.dart';

class AlarmDialog extends StatelessWidget {
  final String arrmsg;
  final Function(int, String) onSetAlarm;

  AlarmDialog({required this.arrmsg, required this.onSetAlarm});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controllerBefore = TextEditingController();

    int parseArrmsg(String arrmsg) {
      final RegExp regex = RegExp(r'(\d+)분(?:\s*(\d+)초)?후');
      final match = regex.firstMatch(arrmsg.replaceAll(' ', ''));

      if (match != null) {
        int minutes = int.parse(match.group(1) ?? '0');
        int seconds = int.parse(match.group(2) ?? '0');
        return (minutes * 60) + seconds;
      }

      return 0;
    }

    void showTopMessage(String message) {
      final overlay = Overlay.of(context);
      final overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: 50.0, // 원하는 위치 조정
          left: 0,
          right: 0,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );

      overlay.insert(overlayEntry);

      Future.delayed(Duration(seconds: 6), () {
        overlayEntry.remove();
      });
    }

    return AlertDialog(
      title: Text('알람 설정'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('이 버스는 "$arrmsg" 도착합니다. 알람을 몇 분 전 설정하시겠습니까?'),
          TextField(
            controller: controllerBefore,
            decoration: InputDecoration(
              labelText: '도착 몇 분 전',
              hintText: '예: 3분 전',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('취소'),
        ),
        TextButton(
          onPressed: () {
            int remainingTime = parseArrmsg(arrmsg);
            int userInputBefore = int.tryParse(controllerBefore.text) ?? 0;
            int alarmTimeInMinutes = (remainingTime ~/ 60) - userInputBefore;

            if (userInputBefore > remainingTime ~/ 60) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('경고'),
                  content: Text('설정한 시간이 예상 시간보다 깁니다.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('확인'),
                    ),
                  ],
                ),
              );
            } else {
              if (alarmTimeInMinutes > 0) {
                onSetAlarm(alarmTimeInMinutes, controllerBefore.text);
              } else {
                onSetAlarm(1, controllerBefore.text);
              }
              Navigator.of(context).pop(); // AlertDialog를 닫습니다.
              showTopMessage('${alarmTimeInMinutes}분 후에 알람이 설정되었습니다.'); // 메시지 표시
            }
          },
          child: Text('설정'),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class AlarmDialog extends StatelessWidget {
  final String arrmsg;
  final Function(int) onSetAlarm;

  AlarmDialog({required this.arrmsg, required this.onSetAlarm});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controllerBefore = TextEditingController();

    // 도착 시간을 파싱하여 남은 시간을 초로 반환하는 함수
    int parseArrmsg(String arrmsg) {
      final RegExp regex = RegExp(r'(\d+)분(?:\s*(\d+)초)?후');
      final match = regex.firstMatch(arrmsg.replaceAll(' ', '')); // 공백 제거

      if (match != null) {
        int minutes = int.parse(match.group(1) ?? '0');
        int seconds = int.parse(match.group(2) ?? '0');
        return (minutes * 60) + seconds; // 총 초로 반환
      }

      return 0; // 파싱 실패 시 0초 반환
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
            print(remainingTime);
            print(2222222222);
            // 도착 시간에서 사용자가 입력한 시간만큼 뺀 후 알람을 설정
            int alarmTimeInMinutes = (remainingTime ~/ 60) - userInputBefore;
            print(alarmTimeInMinutes);
            print(3333333333333);
            if (userInputBefore > remainingTime ~/ 60) {
              // 설정한 시간이 예상 시간보다 클 경우 경고 메시지
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('경고'),
                  content: Text('설정한 시간이 예상 시간보다 깁니다.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // 경고 대화 상자 닫기
                      },
                      child: Text('확인'),
                    ),
                  ],
                ),
              );
            } else {
              // 최소 1분 후 알람으로 설정
              if (alarmTimeInMinutes > 0) {
                onSetAlarm(alarmTimeInMinutes);
              } else {
                onSetAlarm(1);
              }
              Navigator.of(context).pop();
            }
          },
          child: Text('설정'),
        ),
      ],
    );
  }
}

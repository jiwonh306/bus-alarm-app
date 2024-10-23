import 'package:flutter/material.dart';

class AlarmDialog extends StatelessWidget {
  final String arrmsg;
  final Function(int) onSetAlarm;

  AlarmDialog({required this.arrmsg, required this.onSetAlarm});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return AlertDialog(
      title: Text('알람 설정'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('이 버스는 "$arrmsg" 도착합니다. 몇 분 후에 알람을 설정하시겠습니까?'),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: '분',
              hintText: '예: 5분',
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
            int minutes = int.tryParse(controller.text) ?? 0;
            onSetAlarm(minutes);
            Navigator.of(context).pop();
          },
          child: Text('설정'),
        ),
      ],
    );
  }
}
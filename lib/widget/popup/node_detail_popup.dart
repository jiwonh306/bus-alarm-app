import 'package:flutter/material.dart';

class NodeDetailPopup extends StatelessWidget {
  final List<String> busList;
  final String nodenm;

  NodeDetailPopup({required this.busList, required this.nodenm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: DefaultTabController(
        length: 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                nodenm,
                style: TextStyle( fontSize: 18.0, fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TabBar(
              tabs: [
                Tab(text: "버스 정보"),
                Tab(text: "Tab 2"),
              ],
            ),
            Container(
              height: 200, // 팝업의 높이를 설정합니다.
              child: TabBarView(
                children: [
                  Center(
                    child: ListView.builder(
                      itemCount: busList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(busList[index]),
                        );
                      },
                    ),
                  ),
                  Center(child: Text("Tab 2 Content")),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            )
          ],
        ),
      ),
    );
  }
}
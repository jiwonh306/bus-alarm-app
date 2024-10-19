import 'package:bus_alarm_app/model/bus_station_info_model.dart';
import 'package:flutter/material.dart';

import '../service/local_storage_service.dart';

class BookmarkPage extends StatefulWidget {
  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  final BookmarkService _bookmarkService = BookmarkService();
  List<BusStationInfo> _bookmarks = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    List<BusStationInfo> bookmarks = await _bookmarkService.loadBookmarks();
    setState(() {
      _bookmarks = bookmarks;
    });
  }

  void _addBookmark() {
    final title = _titleController.text;
    final url = _urlController.text;

    if (title.isNotEmpty && url.isNotEmpty) {
      final bookmark = BusStationInfo(arsId: , dist: ,gpsX: ,gpsY: ,posX: ,posY: ,stationId: ,stationNm: ,stationTp: );
      setState(() {
        _bookmarks.add(bookmark);
      });
      _bookmarkService.saveBookmarks(_bookmarks);
      _titleController.clear();
      _urlController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('즐겨찾기')),
      body: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: '제목'),
          ),
          TextField(
            controller: _urlController,
            decoration: InputDecoration(labelText: 'URL'),
          ),
          ElevatedButton(
            onPressed: _addBookmark,
            child: Text('추가'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _bookmarks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_bookmarks[index].title),
                  subtitle: Text(_bookmarks[index].url),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

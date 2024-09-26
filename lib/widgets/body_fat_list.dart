import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/body_fat_log.dart';
import '../services/database_service.dart';

class BodyFatList extends StatefulWidget {
  const BodyFatList({super.key});

  @override
  BodyFatListState createState() {
    return BodyFatListState();
  }
}

class BodyFatListState extends State<BodyFatList> {
  final DatabaseService _databaseService = DatabaseService.instance;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: FutureBuilder(
      future: _databaseService.getLogs(),
      builder: (context, snapshot) {
        return ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, int index) {
            BodyFatLog item = snapshot.data![index];
            return _listItem(item);
          },
          separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(height: 16),
        );
      },
    ));
  }

  _listItem(BodyFatLog item) {
    final bfPercentage = '${item.fatPercentage.toStringAsFixed(0)}%';
    final kgValue = '32kg';
    return Container(
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: ListTile(
        onLongPress: () {
          _databaseService.deleteLog(item.id);
          setState(() {});
        },
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat('dd/MM/yyyy').format(item.date)),
                Text('60kg')
              ],
            ),
            Row(
              children: [
                Text("Body Fat: ${bfPercentage} - $kgValue"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

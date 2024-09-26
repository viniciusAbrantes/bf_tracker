import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/strings.dart';
import '../models/body_fat_log.dart';
import '../services/database_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _profileName = '';
  final DatabaseService _databaseService = DatabaseService.instance;
  String? _fatPercentage;

  @override
  void initState() {
    super.initState();
    loadProfileName().then((result) {
      setState(() {
        _profileName = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, Strings.profilePage);
            },
          )
        ],
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          Strings.appTitle,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              Strings.welcomeBack + _profileName,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 16),
            Expanded(child: _bfList()),
          ],
        ),
      ),
      floatingActionButton: _addBfButton(),
    );
  }

  Widget _addBfButton() {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text(Strings.bfDialogTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _fatPercentage = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: Strings.bfLogHint,
                  ),
                ),
                MaterialButton(
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    if (_fatPercentage == null || _fatPercentage == "") return;
                    _databaseService.addLog(double.parse(_fatPercentage!));
                    setState(() {
                      _fatPercentage = null;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text(
                    Strings.bfDoneButton,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: const Icon(
        Icons.add,
      ),
    );
  }

  Widget _bfList() {
    return FutureBuilder(
      future: _databaseService.getLogs(),
      builder: (context, snapshot) {
        return ListView.builder(
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, index) {
            BodyFatLog log = snapshot.data![index];
            return ListTile(
              onLongPress: () {
                _databaseService.deleteLog(log.id);
                setState(() {});
              },
              title: Text(log.fatPercentage.toString()),
            );
          },
        );
      },
    );
  }

  Future<String> loadProfileName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(Strings.profileNameKey)?.split(' ').first ?? '';
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/strings.dart';
import '../models/body_fat_log.dart';
import '../services/database_service.dart';
import '../widgets/body_fat_list.dart';

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
              '${Strings.welcomeBack}, $_profileName :)',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 16),
            BodyFatList()
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
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_fatPercentage == null || _fatPercentage == "") {
                        return;
                      }
                      _databaseService.addLog(double.parse(_fatPercentage!));
                      setState(() {
                        _fatPercentage = null;
                      });
                      Navigator.pop(context);
                    },
                    child: const Text(Strings.saveButton),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: const Icon(Icons.add),
    );
  }

  Future<String> loadProfileName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(Strings.profileNameKey)?.split(' ').first ?? '';
  }
}

import 'package:bf_tracker/widgets/body_fat_list.dart';
import 'package:bf_tracker/widgets/log_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

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
  Future<List<BodyFatLog>> logs = DatabaseService.instance.getLogs();

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
            SizedBox(height: 200, child: LogLineChart(logs)),
            const SizedBox(height: 16),
            BodyFatList()
            //_logList()
          ],
        ),
      ),
      floatingActionButton: _addBfButton(),
    );
  }

  Widget _addBfButton() {
    final formKey = GlobalKey<FormState>();
    final bfPercentageController = TextEditingController();
    final weightController = TextEditingController();
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text(Strings.bfDialogTitle),
            content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: weightController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || double.tryParse(value) == null) {
                          return Strings.invalidWeight;
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: Strings.weightHint,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: bfPercentageController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || double.tryParse(value) == null) {
                          return Strings.invalidPercentage;
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: Strings.bfPercentageHint,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (!formKey.currentState!.validate()) return;
                          saveBfLog(double.parse(weightController.text),
                              double.parse(bfPercentageController.text), () {
                            bfPercentageController.text = '';
                            setState(() {
                              logs = _databaseService.getLogs();
                            });
                            Navigator.pop(context);
                          });
                        },
                        child: const Text(Strings.saveButton),
                      ),
                    ),
                  ],
                )),
          ),
        );
      },
      child: const Icon(Icons.add),
    );
  }

  void saveBfLog(double weight, double bf, VoidCallback onSuccess) async {
    await _databaseService.addLog(weight, bf);
    onSuccess.call();
  }

  Future<String> loadProfileName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(Strings.profileNameKey)?.split(' ').first ?? '';
  }
}

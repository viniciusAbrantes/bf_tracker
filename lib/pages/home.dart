import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/strings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _profileName = '';

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
          children: <Widget>[
            Text('Welcome back, $_profileName',
                style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<String> loadProfileName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(Strings.profileNameKey)
        ?.split(' ').first ?? '';
  }
}

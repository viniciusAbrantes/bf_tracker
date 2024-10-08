import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/strings.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          centerTitle: true,
          title: const Text(
            Strings.profilePageTitle,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: const ProfileForm(),
        ));
  }
}

class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key});

  @override
  ProfileFormState createState() {
    return ProfileFormState();
  }
}

class ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final heightController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    loadProfileData();
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(Strings.name),
          TextFormField(
            decoration: const InputDecoration(hintText: Strings.nameHint),
            controller: nameController,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return Strings.invalidName;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          const Text(Strings.height),
          TextFormField(
            decoration: const InputDecoration(hintText: Strings.heightHint),
            controller: heightController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || double.tryParse(value) == null) {
                return Strings.invalidHeight;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          const Text(Strings.age),
          TextFormField(
            decoration: const InputDecoration(hintText: Strings.ageHint),
            controller: ageController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || int.tryParse(value) == null) {
                return Strings.invalidAge;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;
                await saveProfileData(() {
                  if (!mounted) return;
                  Navigator.pushNamed(context, Strings.homePage);
                });
              },
              child: const Text(Strings.saveButton),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> saveProfileData(VoidCallback onSuccess) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(Strings.profileNameKey, nameController.text);
    await prefs.setString(Strings.profileAgeKey, ageController.text);
    await prefs.setString(Strings.profileHeightKey, heightController.text);

    onSuccess.call();
  }

  Future<void> loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    nameController.text = prefs.getString(Strings.profileNameKey) ?? '';
    ageController.text = prefs.getString(Strings.profileAgeKey) ?? '';
    heightController.text = prefs.getString(Strings.profileHeightKey) ?? '';
  }
}

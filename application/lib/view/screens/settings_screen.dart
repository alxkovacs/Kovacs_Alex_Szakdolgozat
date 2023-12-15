import 'package:application/utils/colors.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view_model/settings_screen_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final settingsScreenViewModel =
        Provider.of<SettingsScreenViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          TranslationEN.settings,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
                top: 15,
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  TranslationEN.manageAccount,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppColor.mainColor),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: Container(
                color: AppColor.mainColor.withOpacity(0.15),
                child: ListTile(
                  visualDensity: const VisualDensity(vertical: -2),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 0.0),
                  leading: const Icon(
                    Icons.account_circle,
                    color: AppColor.mainColor,
                  ),
                  title: const Text(
                    TranslationEN.profile,
                    style: TextStyle(
                        color: AppColor.mainColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: AppColor.mainColor.withOpacity(0.75),
                  ),
                  onTap: () {
                    settingsScreenViewModel.goToProfileScreen(context);
                  },
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();

                if (mounted) {
                  settingsScreenViewModel.goToStartScreen(context);
                  settingsScreenViewModel.resetSelectedIndex();
                }
              },
              child: const Text(
                TranslationEN.signOut,
                style: TextStyle(
                  color: AppColor.mainColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

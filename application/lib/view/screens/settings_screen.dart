import 'package:application/providers/base_view_model_provider.dart';
import 'package:application/utils/colors.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view_model/settings_screen_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _firebase = FirebaseAuth.instance;

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    SettingsScreenViewModel viewModel = SettingsScreenViewModel();
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
            const SizedBox(height: 15),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  TranslationEN.manageAccount,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppColor.mainColor),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              color: AppColor.mainColor.withOpacity(0.15),
              child: ListTile(
                visualDensity: const VisualDensity(vertical: -2),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
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
                  // Navigate to profile page or perform action
                  viewModel.goToProfileScreen(context);
                },
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.topLeft,
              child: TextButton(
                onPressed: () async {
                  // Felhasználó kijelentkeztetése.
                  await FirebaseAuth.instance.signOut();

                  // Navigálás a kezdőképernyőre és az előzmények törlése.
                  if (mounted) {
                    viewModel.goToStartScreen(context);
                  }
                  ref.read(baseViewModelProvider.notifier).resetSelectedIndex();
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
            ),
          ],
        ),
      ),
    );
  }
}

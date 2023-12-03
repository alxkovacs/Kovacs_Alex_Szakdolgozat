import 'package:application/providers/profile_view_model_provider.dart';
import 'package:application/utils/colors.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view/widgets/auth_input_decoration.dart';
import 'package:application/view/widgets/custom_circular_progress_indicator.dart';
import 'package:application/view/widgets/custom_elevated_button.dart';
import 'package:application/view_model/profile_screen_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final viewModel = ref.read(profileViewModelProvider);
      await viewModel.loadUserData();
      _firstNameController.text = viewModel.firstName;
    });
  }

  Future<void> _updateFirstName(ProfileScreenViewModel viewModel) async {
    if (_formKey.currentState!.validate()) {
      // ViewModel metódusának meghívása
      await viewModel.updateFirstName(_firstNameController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(
        profileViewModelProvider); // Feltételezve, hogy van egy ilyen providered

    bool isLoading = viewModel.isLoading;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          TranslationEN.profile,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: isLoading
          ? const CustomCircularProgressIndicator()
          : Column(
              children: <Widget>[
                const Center(
                  child: Icon(
                    Icons.person,
                    size: 150,
                    color: AppColor.mainColor,
                  ),
                ),
                const Text(
                  TranslationEN.changeFirstName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 35), // 24 volt
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _firstNameController,
                          decoration: AuthInputDecoration(
                            labelText: TranslationEN.firstName,
                            iconData: Icons.person_2_outlined,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().length < 3) {
                              return TranslationEN.firstNameValidator;
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomElevatedButton(
                          onPressed: () => _updateFirstName(viewModel),
                          text: TranslationEN.save,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

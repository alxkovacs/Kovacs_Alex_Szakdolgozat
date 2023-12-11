import 'package:application/utils/colors.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view/widgets/auth_input_decoration.dart';
import 'package:application/view/widgets/custom_circular_progress_indicator.dart';
import 'package:application/view/widgets/custom_elevated_button.dart';
import 'package:application/view_model/home_screen_view_model.dart';
import 'package:application/view_model/profile_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final viewModel =
          Provider.of<ProfileScreenViewModel>(context, listen: false);
      await viewModel.loadUserData();
      _firstNameController.text = viewModel.firstName;
    });
  }

  Future<void> _updateFirstName(ProfileScreenViewModel viewModel) async {
    if (_formKey.currentState!.validate()) {
      await viewModel.updateFirstName(_firstNameController.text.trim());
      Provider.of<HomeScreenViewModel>(context, listen: false)
          .refreshUserName();
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileScreenviewModel = Provider.of<ProfileScreenViewModel>(context);
    bool isLoading = profileScreenviewModel.isLoading;

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
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: TextFormField(
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
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: CustomElevatedButton(
                            onPressed: () =>
                                _updateFirstName(profileScreenviewModel),
                            text: TranslationEN.save,
                          ),
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

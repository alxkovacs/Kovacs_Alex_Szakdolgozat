import 'package:application/utils/colors.dart';
import 'package:application/view/widgets/auth_image_widget.dart';
import 'package:application/view/widgets/auth_input_decoration.dart';
import 'package:application/view/widgets/custom_elevated_button.dart';
import 'package:application/view_model/sign_up_view_model.dart';
import 'package:flutter/material.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SignUpViewModel viewModel = SignUpViewModel();
    final _form = GlobalKey<FormState>();

    bool _isLoading = false;

    var _enteredFirstName = '';
    var _enteredEmail = '';
    var _enteredPassword = '';

    return Center(
      child: _isLoading
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColor.mainColor),
            ) // Töltés ikon megjelenítése
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AuthImageWidget(
                    imagePath: 'assets/images/sign_up_screen_image.png',
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20), // 24 volt
                      child: Form(
                        key: _form,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 20),
                            TextFormField(
                              decoration: AuthInputDecoration(
                                labelText: 'Terméknév',
                                iconData: Icons.qr_code_2,
                              ),
                              autocorrect: true,
                              textCapitalization: TextCapitalization.sentences,
                              validator: (value) {
                                if (value == null || value.trim().length < 3) {
                                  return 'A névnek legalább 3 karakter hosszúnak kell lennie.';
                                }

                                return null;
                              },
                              onSaved: (value) {
                                // _enteredFirstName = value!;
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              decoration: AuthInputDecoration(
                                labelText: 'Gyártó',
                                iconData: Icons.precision_manufacturing,
                              ),
                              autocorrect: true,
                              textCapitalization: TextCapitalization.sentences,
                              validator: (value) {
                                if (value == null || value.trim().length < 3) {
                                  return 'A névnek legalább 3 karakter hosszúnak kell lennie.';
                                }

                                return null;
                              },
                              onSaved: (value) {
                                // _enteredFirstName = value!;
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              decoration: AuthInputDecoration(
                                labelText: 'Üzlet',
                                iconData: Icons.shopping_cart,
                              ),
                              autocorrect: true,
                              textCapitalization: TextCapitalization.sentences,
                              validator: (value) {
                                if (value == null || value.trim().length < 3) {
                                  return 'A névnek legalább 3 karakter hosszúnak kell lennie.';
                                }

                                return null;
                              },
                              onSaved: (value) {
                                // _enteredFirstName = value!;
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              decoration: AuthInputDecoration(
                                labelText: 'Ár',
                                iconData: Icons.attach_money,
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Kérlek valós összeget adj meg.';
                                }

                                return null;
                              },
                              onSaved: (value) {
                                // _enteredEmail = value!;
                              },
                            ),
                            const SizedBox(height: 30),
                            CustomElevatedButton(
                              onPressed: () {},
                              text: 'Hozzáadás',
                            ),
                          ],
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

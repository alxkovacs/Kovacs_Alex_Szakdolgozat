import 'package:application/utils/colors.dart';
import 'package:application/view/widgets/auth_image_widget.dart';
import 'package:application/view/widgets/auth_input_decoration.dart';
import 'package:application/view/widgets/custom_elevated_button.dart';
import 'package:application/view_model/add_store_view_model.dart';
import 'package:flutter/material.dart';

class AddStoreScreen extends StatefulWidget {
  const AddStoreScreen({super.key});

  @override
  State<AddStoreScreen> createState() => _AddStoreScreenState();
}

class _AddStoreScreenState extends State<AddStoreScreen> {
  AddStoreViewModel viewModel = AddStoreViewModel();
  final _form = GlobalKey<FormState>();

  bool _isLoading = false;

  var _enteredStoreName = '';
  var _enteredPostcode = '';
  var _enteredCity = '';
  var _enteredAddress = '';

  @override
  Widget build(BuildContext context) {
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
                                labelText: 'Üzletnév',
                                iconData: Icons.trolley,
                              ),
                              autocorrect: true,
                              textCapitalization: TextCapitalization.sentences,
                              validator: (value) {
                                if (value == null || value.trim().length < 3) {
                                  return 'Az üzletnévnek legalább 3 karakter hosszúnak kell lennie.';
                                }

                                return null;
                              },
                              onSaved: (value) {
                                _enteredStoreName = value!;
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              decoration: AuthInputDecoration(
                                labelText: 'Irányítószám',
                                iconData: Icons.local_post_office_rounded,
                              ),
                              autocorrect: true,
                              textCapitalization: TextCapitalization.sentences,
                              validator: (value) {
                                if (value == null || value.trim().length != 4) {
                                  return 'Az irányítószámnak 4 karakter hosszúnak kell lennie.';
                                }

                                return null;
                              },
                              onSaved: (value) {
                                _enteredPostcode = value!;
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              decoration: AuthInputDecoration(
                                labelText: 'Város',
                                iconData: Icons.location_city,
                              ),
                              autocorrect: true,
                              textCapitalization: TextCapitalization.sentences,
                              validator: (value) {
                                if (value == null || value.trim().length < 3) {
                                  return 'A városnévnek legalább 3 karakter hosszúnak kell lennie.';
                                }

                                return null;
                              },
                              onSaved: (value) {
                                _enteredCity = value!;
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              decoration: AuthInputDecoration(
                                labelText: 'Cím',
                                iconData: Icons.location_on,
                              ),
                              autocorrect: true,
                              textCapitalization: TextCapitalization.sentences,
                              validator: (value) {
                                if (value == null || value.trim().length < 3) {
                                  return 'A címnek legalább 3 karakter hosszúnak kell lennie.';
                                }

                                return null;
                              },
                              onSaved: (value) {
                                _enteredAddress = value!;
                              },
                            ),
                            const SizedBox(height: 30),
                            CustomElevatedButton(
                              onPressed: () async {
                                if (_form.currentState!.validate()) {
                                  setState(() => _isLoading = true);
                                  _form.currentState!.save();
                                  bool success = await viewModel.addStore(
                                      _enteredStoreName,
                                      _enteredPostcode,
                                      _enteredCity,
                                      _enteredAddress);

                                  if (success) {
                                    if (mounted) {
                                      Navigator.pop(context);
                                    }
                                  } else {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .clearSnackBars();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Sikertelen áruház hozzáadás!'),
                                        ),
                                      );
                                    }
                                  }
                                  await Future.delayed(
                                    const Duration(milliseconds: 100),
                                  );
                                  if (mounted) {
                                    setState(() => _isLoading = false);
                                  }
                                }
                              },
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

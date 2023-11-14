import 'package:application/view/widgets/auth_input_decoration.dart';
import 'package:application/view/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'Profil',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: Icon(
              Icons.person,
              size: 150,
              color: const Color.fromRGBO(67, 153, 182, 1.00),
            ),
            // child: Text(
            //   '👤',
            //   style: TextStyle(fontSize: 50),
            // ),
          ),
          Text(
            'Keresztnév megváltoztatása',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35), // 24 volt
            child: Form(
              key: _form,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: AuthInputDecoration(
                      labelText: 'Keresztnév',
                      iconData: Icons.person_2_outlined,
                    ),
                    // textCapitalization: TextCapitalization.,
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
                  const SizedBox(height: 20),
                  CustomElevatedButton(
                    onPressed: () {},
                    text: 'Mentés',
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

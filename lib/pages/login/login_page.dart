import 'package:chat_flutter_firebase/widgets/custom_button.dart';
import 'package:chat_flutter_firebase/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomFormField(controller: controller, labelText: 'E-mail', padding: const EdgeInsets.only(bottom: 10)),
              CustomFormField(controller: controller, labelText: 'Senha'),
              const CustomButton(
                label: 'Login',
                padding: EdgeInsets.symmetric(vertical: 10),
              )
            ],
          ),
        ),
      ),
    );
  }
}

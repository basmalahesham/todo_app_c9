import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/widgets/custom_text_form_field.dart';
import 'package:todo_app/layout/home_layout.dart';
import 'package:todo_app/moduls/register/register_screen.dart';

import '../../core/services/snackbar_service.dart';
import '../../provider/settings_provider.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  static const String routeName = "login_screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //String name = '';
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SettingsProvider>(context);
    var mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.only(
          top: mediaQuery.height * 0.09,
          left: 20,
          right: 20,
        ),
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/SIGN IN – 1.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Login',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: mediaQuery.height * 0.2,
              ),
              Text(
                'Welcome back!',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: provider.isDark() ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(
                height: mediaQuery.height * 0.015,
              ),
              CustomTextFormField(
                controller: emailController,
                label: 'Email Address',
                hint: 'Enter your email address',
                validator: (value) {
                  if (value == null || value!.trim().isEmpty) {
                    return 'Please enter your email address';
                  }
                  var regex = RegExp(
                      r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9]+\.[a-zA-Z0-9-.]+$)");
                  if (!regex.hasMatch(value)) {
                    return 'enter a valid email address';
                  }
                  return null;
                },
              ),
              CustomTextFormField(
                controller: passwordController,
                label: 'Password',
                hint: 'Enter your Password',
                validator: (value) {
                  if (value == null || value!.trim().isEmpty) {
                    return 'Please enter your password';
                  }
                  var regex = RegExp(
                      r"(?=^.{8,}$)(?=.*[!@#$%^&*]+)(?![.\\n])(?=.*[A-Z])(?=.*[a-z]).*$");
                  if (!regex.hasMatch(value)) {
                    return 'enter a valid password';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: ElevatedButton(
                  onPressed: () {
                    login();
                  },
                  child: Text(
                    'Login',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: mediaQuery.height * 0.015,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "if you don't have an account?.",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: provider.isDark() ? Colors.white : Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RegisterScreen.routeName);
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void register() async {
    // print(nameController.text);
    // formKey.currentState?.validate();
    if (formKey.currentState!.validate()) {
      // authenticate with firebase
      try {
        EasyLoading.show();
        final userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        print(userCredential.user);
        EasyLoading.dismiss();
        SnackBarService.showSuccessMessage(
            'The account was registered successfully');
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          EasyLoading.dismiss();
          SnackBarService.showErrorMessage(
              'The password provided is too weak.');
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          EasyLoading.dismiss();
          SnackBarService.showErrorMessage(
              'The account already exists for that email.');
          print('The account already exists for that email.');
        }
      } catch (e) {
        EasyLoading.dismiss();
        SnackBarService.showErrorMessage(
            'no network please check internet connection');
        print(e);
      }
    }
  }

  void login() async {
    if (formKey.currentState!.validate()) {
      try {
        EasyLoading.show();
        final credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        EasyLoading.dismiss();
        SnackBarService.showSuccessMessage('you are login successfully');
        Navigator.pushNamedAndRemoveUntil(
            context, HomeLayoutView.routeName, (route) => false);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          EasyLoading.dismiss();
          SnackBarService.showErrorMessage('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          EasyLoading.dismiss();
          SnackBarService.showErrorMessage(
              'Wrong password provided for that user.');
        }
      }
    }
  }
}

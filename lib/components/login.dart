import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:task_back4app/components/text_form_field.dart';
import 'package:task_back4app/components/loader_dialog.dart';
import 'package:task_back4app/providers/user_provider.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback toggleIsSigningUp;

  const LoginPage({super.key, required this.toggleIsSigningUp});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var isObscure = true;

  void handleLoginTap(UserProvider userContext) async {
    final isFormValid = _formKey.currentState!.validate();
    if (isFormValid) {
      showLoaderDialog(context, "Signing in...");

      final response = await userContext.signin(
        usernameController.text.trim(),
        passwordController.text.trim(),
      );

      if (context.mounted) Navigator.of(context).pop();

      if (context.mounted) {
        if (!response.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 1),
              content: Text(
                response.error!.message,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        } else {
          usernameController.clear();
          passwordController.clear();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userContext, child) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff1E2E3D),
                        Color(0xff152534),
                        Color(0xff0C1C2E),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tasks Management',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 38,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Sign in to your\nAccount',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          'Enter Account Details',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextFormField(
                        labelText: 'Username',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter username.";
                          }
                          return null;
                        },
                        controller: usernameController,
                      ),
                      CustomTextFormField(
                        labelText: 'Password',
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter password.";
                          }
                          return null;
                        },
                        controller: passwordController,
                        obscureText: isObscure,
                        maxLines: 1,
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                isObscure = !isObscure;
                              });
                            },
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all(
                                const Size(48, 48),
                              ),
                            ),
                            icon: Icon(
                              isObscure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () => handleLoginTap(userContext),
                          style: const ButtonStyle().copyWith(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xff1E2E3D)),
                          ),
                          child: const Text('Login'),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.black),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: TextButton(
                          onPressed: widget.toggleIsSigningUp,
                          style: Theme.of(context).textButtonTheme.style,
                          child: Text(
                            'Register',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: const Color(0xff1E2E3D),
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

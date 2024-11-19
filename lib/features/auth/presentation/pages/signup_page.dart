import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';
import 'package:uni_app/features/auth/presentation/widgets/my_text_field.dart';

class SignUpPage extends StatefulWidget {
  final Function() toggle;
  const SignUpPage({super.key, required this.toggle});

  @override
  State<SignUpPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<SignUpPage> {
  // controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Widget _buildLoginWithButton(
      {required String assetPath, required String text}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            assetPath,
            width: 30,
            height: 30,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),

                  // logo
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Image.asset(
                      'assets/images/login.png',
                      width: 100,
                      color: Theme.of(context).colorScheme.primary,
                      // height: 250,
                    ),
                  ),
                  const SizedBox(height: 50),

                  // text fields
                  MyTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: _confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),

                  const SizedBox(height: 20),

                  // login button
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // sign up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Have an account?',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                      TextButton(
                        onPressed: widget.toggle,
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // divider
                  Divider(
                    color: Theme.of(context).colorScheme.secondary,
                    height: 20,
                    thickness: 1,
                  ),

                  // google and facebook login
                  Row(
                    children: [
                      Expanded(
                        child: _buildLoginWithButton(
                          assetPath: 'assets/icons/google.svg',
                          text: 'Google',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildLoginWithButton(
                          assetPath: 'assets/icons/facebook.svg',
                          text: 'Facebook',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

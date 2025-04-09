import 'package:flutter/material.dart';
import 'package:hadith_reader/core/app_color.dart';
import 'package:hadith_reader/providers/signup_provider.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignupProvider(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.secondary,
          title: const Text("Create your account", style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        body: const SignupForm(),
      ),
    );
  }
}

class SignupForm extends StatelessWidget {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    final signupController = Provider.of<SignupProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Spacer(),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Join us',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    'to ensure you dont miss out in taking opportunities.',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.visible,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          TextField(
            controller: signupController.nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              errorText: signupController.nameError,
            ),
            onChanged: (value) => signupController.signUpName(value),
          ),
          const SizedBox(height: 20.0),
          TextField(
            controller: signupController.emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              errorText: signupController.emailError,
            ),
            onChanged: (value) => signupController.signUpEmail(value),
          ),
          const SizedBox(height: 20.0),
          TextField(
            controller: signupController.passwordController,
            obscureText: signupController.obscureText,
            decoration: InputDecoration(
              labelText: 'Password',
              suffixIcon: IconButton(
                icon: Icon(
                  signupController.obscureText
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: signupController.toggleObscureText,
              ),
              errorText: signupController.passwordError,
            ),
            onChanged: (value) => signupController.signUpPassword(value),
          ),
          const SizedBox(height: 20.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              label: const Text('Sign Up'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[500],
                foregroundColor: Colors.white,
              ),
              onPressed: () => signupController.signUp(context),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hadith_reader/core/app_color.dart';
import 'package:hadith_reader/providers/login_provider.dart';
import 'package:hadith_reader/screen/signup_page_view.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginProvider(),
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Consumer<LoginProvider>(
              builder: (context, loginController, _) {
                return Form(
                  key: loginController.formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 8),
                          Text(
                            'Log in to Muslim Helper',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: loginController.emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: const TextStyle(
                                    color: AppColors.textPrimary),
                                errorText: loginController.emailError,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: const BorderSide(
                                      color: AppColors.textPrimary),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.textPrimary, width: 2),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.textPrimary, width: 1),
                                ),
                              ),
                              style:
                                  const TextStyle(color: AppColors.textPrimary),
                              onChanged: loginController.updateEmail,
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              controller: loginController.passwordController,
                              obscureText: loginController.obscureText,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: const TextStyle(
                                    color: AppColors.textPrimary),
                                errorText: loginController.passwordError,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: const BorderSide(
                                      color: AppColors.textPrimary),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.textPrimary, width: 2),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.textPrimary, width: 1),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    loginController.obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: loginController.toggleObscureText,
                                ),
                              ),
                              style: const TextStyle(color: AppColors.primary),
                              onChanged: loginController.updatePassword,
                            ),
                            const SizedBox(height: 20.0),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.login),
                                label: const Text('Log In'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.textTertiaty,
                                  foregroundColor: Colors.black,
                                ),
                                onPressed: () => loginController.login(context),
                              ),
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SignupPage()),
                                );
                              },
                              child: const Text(
                                'Join us if you have not yet!',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

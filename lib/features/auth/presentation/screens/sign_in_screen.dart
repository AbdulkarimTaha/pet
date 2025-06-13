import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:petscare/api/api_service.dart';
import 'package:petscare/api/user_service.dart';
import 'package:petscare/features/home/presentation/screens/main_screen.dart';
import 'package:petscare/features/clinic/presentation/screens/clinic_profile_screen.dart';
import 'package:petscare/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:petscare/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  final String role;
  const SignInScreen({super.key, required this.role});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late final List<Map<String, dynamic>> fields;

  bool passwordVisible = false;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fields = [
      {
        "text": "Email",
        "keyboardtype": TextInputType.emailAddress,
        "obscuretext": false,
        "Controller": emailController,
        "prefixIcon": Icons.email,
        "suffixIcon": false,
        "textColor": const Color(0xff222222),
        "validator": (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email';
          }
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return 'Please enter a valid email';
          }
          return null;
        },
      },
      {
        "text": "Password",
        "keyboardtype": TextInputType.text,
        "obscuretext": true,
        "Controller": passwordController,
        "prefixIcon": Icons.lock,
        "suffixIcon": true,
        "textColor": const Color(0xff222222),
        "validator": (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          if (value.length < 8) {
            return 'Password must be at least 8 characters';
          }
          return null;
        },
      },
    ];
  }

  void _showErrorDialog(String errorMessage) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: 'Error',
      desc: errorMessage,
      btnOkOnPress: () {},
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final padding = MediaQuery.of(context).padding;
    
    // Calculate responsive values
    final double topPadding = size.height * 0.15; // 15% of screen height
    final double horizontalPadding = size.width * 0.07; // 7% of screen width
    final double fieldSpacing = size.height * 0.02; // 2% of screen height
    final double buttonHeight = size.height * 0.06; // 6% of screen height

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  color: const Color(0xffF6F6F6),
                  padding: EdgeInsets.only(
                    top: topPadding,
                    left: horizontalPadding,
                    right: horizontalPadding,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Let's Get You \nSign In !",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: const Color(0xff222222),
                            fontSize: 28 * textScaleFactor,
                            fontFamily: 'Poppins2',
                            letterSpacing: 2.24,
                          ),
                        ),
                        SizedBox(height: fieldSpacing * 1.5),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: fields.length,
                          itemBuilder: (context, index) {
                            final field = fields[index];
                            final isPasswordField = field["text"]
                                .toString()
                                .toLowerCase()
                                .contains('password');
                            return Padding(
                              padding: EdgeInsets.only(bottom: fieldSpacing),
                              child: CustomTextFormField(
                                hintText: field["text"],
                                keyboardType: field["keyboardtype"],
                                obscureText:
                                    isPasswordField ? !passwordVisible : false,
                                controller: field["Controller"],
                                prefixIcon: field["prefixIcon"],
                                suffixIcon: isPasswordField
                                    ? (passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off)
                                    : null,
                                onSuffixTap: isPasswordField
                                    ? () {
                                        setState(() {
                                          passwordVisible = !passwordVisible;
                                        });
                                      }
                                    : null,
                                textColor: field["textColor"],
                                validator: field["validator"],
                              ),
                            );
                          },
                        ),
                        SizedBox(height: fieldSpacing * 2),
                        SizedBox(
                          width: double.infinity,
                          height: buttonHeight,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  setState(() => _isLoading = true);
                                  FocusScope.of(context).unfocus();

                                  final response = await ApiService.signIn({
                                    'email': emailController.text.trim(),
                                    'password': passwordController.text,
                                    'role': widget.role,
                                  });

                                  if (response.statusCode == 200) {
                                    final responseData = jsonDecode(response.body);
                                    final user = responseData['user'] as Map<String, dynamic>? ?? {};
                                    final userId = user['_id']?.toString() ?? user['id']?.toString();
                                    final username = user['username']?.toString();
                                    final email = user['email']?.toString();

                                    if (userId == null) {
                                      throw Exception('User ID not found in response');
                                    }

                                    await UserService.saveUserData(
                                      userId: userId,
                                      username: username,
                                      email: email,
                                      role: widget.role,
                                    );

                                    if (widget.role == "petOwner") {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MainScreen()),
                                      );
                                    } else if (widget.role == "veterinaryClinic") {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ClinicProfileScreen()),
                                      );
                                    }
                                  } else {
                                    final error = jsonDecode(response.body)?['message'] ?? 'Sign-in failed';
                                    _showErrorDialog(error.toString());
                                  }
                                } catch (e) {
                                  _showErrorDialog('Error during sign-in: ${e.toString()}');
                                  debugPrint('Sign-in error: $e');
                                } finally {
                                  if (mounted) setState(() => _isLoading = false);
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff99DDCC),
                              padding: EdgeInsets.zero,
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    "Sign In",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16 * textScaleFactor,
                                      fontFamily: 'Poppins1',
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 2.72,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: padding.bottom + 20,
                left: horizontalPadding,
                right: horizontalPadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t Have An Account ? ',
                    style: TextStyle(
                      color: const Color(0xFF757575),
                      fontSize: 14 * textScaleFactor,
                      fontFamily: 'Poppins1',
                      letterSpacing: 2.38,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUpScreen(
                                  role: widget.role,
                                )),
                      );
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: const Color(0xFF99DDCC),
                        fontSize: 14 * textScaleFactor,
                        fontFamily: 'Poppins1',
                        letterSpacing: 2.38,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:petscare/api/api_service.dart';
import 'package:petscare/api/user_service.dart';
import 'package:petscare/features/home/presentation/screens/main_screen.dart';
import 'package:petscare/features/clinic/presentation/screens/clinic_profile_screen.dart';
import 'package:petscare/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:petscare/features/auth/presentation/screens/sign_in_screen.dart';


class SignUpScreen extends StatefulWidget {
  final String role;
  const SignUpScreen({super.key, required this.role});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController clinicNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool agree = false;
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final List fields;

  @override
  void initState() {
    super.initState();
    fields = _buildFieldsList();
  }

  List<Map<String, dynamic>> _buildFieldsList() {
    final commonFields = [
      {
        "text": "Username",
        "keyboardtype": TextInputType.name,
        "obscuretext": false,
        "Controller": nameController,
        "prefixIcon": Icons.person,
        "suffixIcon": false,
        "textColor": const Color(0xff222222),
        "validator": (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your username';
          }
          if (value.length < 3) {
            return 'Username must be at least 3 characters';
          }
          return null;
        },
      },
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
    ];

    if (widget.role == 'veterinaryClinic') {
      commonFields.insert(1, {
        "text": "Clinic Name",
        "keyboardtype": TextInputType.name,
        "obscuretext": false,
        "Controller": clinicNameController,
        "prefixIcon": Icons.business,
        "suffixIcon": false,
        "textColor": const Color(0xff222222),
        "validator": (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter clinic name';
          }
          return null;
        },
      });
    }

    return [
      ...commonFields,
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
      {
        "text": "Confirm Password",
        "keyboardtype": TextInputType.text,
        "obscuretext": true,
        "Controller": confirmPasswordController,
        "prefixIcon": Icons.lock,
        "suffixIcon": true,
        "textColor": const Color(0xff222222),
        "validator": (value) {
          if (value == null || value.isEmpty) {
            return 'Please confirm your password';
          }
          if (value != passwordController.text) {
            return 'Passwords do not match';
          }
          return null;
        },
      },
      if (widget.role == 'veterinaryClinic')
        {
          "text": "Address",
          "keyboardtype": TextInputType.streetAddress,
          "obscuretext": false,
          "Controller": addressController,
          "prefixIcon": Icons.location_on,
          "suffixIcon": false,
          "textColor": const Color(0xff222222),
          "validator": (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter clinic address';
            }
            return null;
          },
        },
      if (widget.role == 'veterinaryClinic')
        {
          "text": "Phone Number",
          "keyboardtype": TextInputType.phone,
          "obscuretext": false,
          "Controller": phoneController,
          "prefixIcon": Icons.phone,
          "suffixIcon": false,
          "textColor": const Color(0xff222222),
          "validator": (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter phone number';
            }
            if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
              return 'Please enter a valid phone number';
            }
            return null;
          },
        },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final padding = MediaQuery.of(context).padding;
    
    // Calculate responsive values
    final double topPadding = size.height * 0.1; // 10% of screen height
    final double horizontalPadding = size.width * 0.07; // 7% of screen width
    final double fieldSpacing = size.height * 0.02; // 2% of screen height
    final double buttonHeight = size.height * 0.06; // 6% of screen height

    return Scaffold(
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
                          widget.role == 'veterinaryClinic'
                              ? "Register Your Clinic"
                              : "Create Your Account",
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
                                obscureText: isPasswordField
                                    ? (field["text"].toString().toLowerCase().contains('confirm')
                                        ? !confirmPasswordVisible
                                        : !passwordVisible)
                                    : false,
                                controller: field["Controller"],
                                prefixIcon: field["prefixIcon"],
                                suffixIcon: isPasswordField
                                    ? (field["text"].toString().toLowerCase().contains('confirm')
                                        ? (confirmPasswordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off)
                                        : (passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off))
                                    : null,
                                onSuffixTap: isPasswordField
                                    ? () {
                                        setState(() {
                                          if (field["text"]
                                              .toString()
                                              .toLowerCase()
                                              .contains('confirm')) {
                                            confirmPasswordVisible =
                                                !confirmPasswordVisible;
                                          } else {
                                            passwordVisible = !passwordVisible;
                                          }
                                        });
                                      }
                                    : null,
                                textColor: field["textColor"],
                                validator: field["validator"],
                              ),
                            );
                          },
                        ),
                        SizedBox(height: fieldSpacing),
                        Row(
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: agree,
                                onChanged: (value) {
                                  setState(() {
                                    agree = value ?? false;
                                  });
                                },
                                activeColor: const Color(0xff99DDCC),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'By creating an account you agree to our Terms of Service and Privacy Policy',
                                style: TextStyle(
                                  color: const Color(0xFF757575),
                                  fontSize: 12 * textScaleFactor,
                                  fontFamily: 'Poppins1',
                                  letterSpacing: 2.04,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: fieldSpacing * 2),
                        SizedBox(
                          width: double.infinity,
                          height: buttonHeight,
                          child: ElevatedButton(
                            onPressed: isLoading || !agree ? null : () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  setState(() => isLoading = true);
                                  FocusScope.of(context).unfocus();

                                  final username = nameController.text.trim();
                                  final email = emailController.text.trim();
                                  final response = await ApiService.signUp({
                                    'username': username,
                                    'email': email,
                                    'password': passwordController.text,
                                    'address': 'amman',
                                    'phoneNumber':'0000000000',
                                    if (widget.role == 'veterinaryClinic') ...{
                                      'clinicName': clinicNameController.text.trim(),
                                      'address': addressController.text.trim(),
                                      'phoneNumber': phoneController.text.trim(),
                                    },
                                    'role': widget.role,
                                  });

                                  if (response.statusCode == 201) {
                                    final responseData = jsonDecode(response.body);
                                    final userId = responseData['id']?.toString();

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
                                            builder: (context) => const MainScreen()),
                                      );
                                    } else if (widget.role == "veterinaryClinic") {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const ClinicProfileScreen()),
                                      );
                                    }
                                  } else {
                                    final error = jsonDecode(response.body)?['message'] ??
                                        'Sign-up failed';
                                    _showErrorDialog(error.toString());
                                  }
                                } catch (e) {
                                  _showErrorDialog('Error during sign-up: ${e.toString()}');
                                  debugPrint('Sign-up error: $e');
                                } finally {
                                  if (mounted) setState(() => isLoading = false);
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff99DDCC),
                              padding: EdgeInsets.zero,
                              elevation: 0,
                              disabledBackgroundColor: const Color(0xff99DDCC).withOpacity(0.5),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    "Sign Up",
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already Have An Account ? ',
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
                                      builder: (context) => SignInScreen(
                                        role: widget.role,
                                      )),
                                );
                              },
                              child: Text(
                                'Sign In',
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: 'Error',
      desc: message,
      btnOkOnPress: () {},
    ).show();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    clinicNameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}

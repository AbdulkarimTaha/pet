import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petscare/api/api_service.dart';
import 'package:petscare/api/user_service.dart';
import 'package:petscare/features/auth/presentation/widgets/custom_text_form_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  File? _profileImage;
  String? _imageUrl;
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    try {
      final name = await UserService.getUserName();
      final email = await UserService.getUserEmail();
      final address = await UserService.getUserAddress();
      // If you store imageUrl in user data, load it here
      setState(() {
        _nameController.text = name ?? '';
        _emailController.text = email ?? '';
        _addressController.text = address ?? '';
      });
    } catch (e) {
      print("Error loading user data: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
      // Upload image and get URL
      final url = await ApiService.uploadImage(_profileImage!);
      setState(() {
        _imageUrl = url;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final userId = await UserService.getUserId();
      if (userId == null) throw Exception("User ID not found");
      final updateData = {
        'name': _nameController.text,
        'address': _addressController.text,
        if (_passwordController.text.isNotEmpty)
          'password': _passwordController.text,
        if (_imageUrl != null) 'imageUrl': _imageUrl,
      };
      final response = await ApiService.updatePetOwnerProfile(userId, updateData);
      if (response.statusCode == 200) {
        await UserService.saveUserData(
          userId: userId,
          username: _nameController.text,
          email: _emailController.text,
          address: _addressController.text,
          // Save imageUrl if you store it
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context);
      } else {
        throw Exception('Failed to update profile: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffF6F6F6),
        body: Stack(
          children: [
            Positioned(
              left: 207,
              top: -342,
              child: Container(
                width: 399,
                height: 432,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(360),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xffBAD7DF).withOpacity(0.3),
                      blurRadius: 300,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  // App Bar
                  Row(
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_new),
                      ),
                      const SizedBox(width: 110),
                      const Text(
                        'Edit Profile',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Poppins3',
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Divider(color: Color(0xffD9D9D9)),
                  const SizedBox(height: 15),
                  // Body
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Profile Picture
                            GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xffD9DEDF),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                ),
                                child: _profileImage != null
                                    ? ClipOval(
                                        child: Image.file(
                                          _profileImage!,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.person,
                                        size: 60,
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            // Name Field using CustomTextFormField
                            CustomTextFormField(
                              hintText: 'Full Name',
                              keyboardType: TextInputType.name,
                              controller: _nameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                              prefixIcon: Icons.person,
                            ),
                            const SizedBox(height: 20),
                            // Email Field using CustomTextFormField
                            CustomTextFormField(
                              hintText: 'Email',
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                              prefixIcon: Icons.email,
                            ),
                            const SizedBox(height: 20),
                            // Address Field
                            CustomTextFormField(
                              hintText: 'Address',
                              keyboardType: TextInputType.streetAddress,
                              controller: _addressController,
                              prefixIcon: Icons.location_on,
                            ),
                            const SizedBox(height: 20),
                            // Password Field using CustomTextFormField
                            CustomTextFormField(
                              hintText: 'New Password',
                              keyboardType: TextInputType.visiblePassword,
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible,
                              prefixIcon: Icons.lock,
                              suffixIcon: _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              onSuffixTap: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                              validator: (value) {
                                if (value != null &&
                                    value.isNotEmpty &&
                                    value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 40),
                            // Save Button
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed:
                                        _isLoading ? null : _updateProfile,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff99DDCC),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      elevation: 0,
                                    ),
                                    child: _isLoading
                                        // ignore: dead_code
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Text(
                                            "Save",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontFamily: 'Poppins1',
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 2.72,
                                            ),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
} 
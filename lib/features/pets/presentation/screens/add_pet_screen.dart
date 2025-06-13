import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petscare/api/api_service.dart';
import 'package:petscare/api/user_service.dart';
import 'package:petscare/core/presentation/widgets/custom_dropdown_field.dart';
import 'package:petscare/core/presentation/widgets/gender_selector_button.dart';
import 'package:petscare/features/auth/presentation/widgets/custom_text_form_field.dart';

class AddPetScreen extends StatefulWidget {
  const AddPetScreen({super.key});

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  late final List fields;
  String? selectedSpecies;
  String? selectedBreed;
  String? selectedGender;
  final List<String> speciesList = ['Dog', 'Cat', 'Bird'];
  final List<String> breedList = ['Breed 1', 'Breed 2', 'Breed 3'];
  File? _selectedImage;
  bool _isLoading = false;
  String? _errorMessage;
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fields = [
      {
        "text": "Enter pet's name",
        "keyboardtype": TextInputType.text,
        "obscuretext": false,
        "Controller": nameController,
        "prefixIcon": false,
        "suffixIcon": false,
        "textColor ": const Color(0xffA0A0A0),
      },
      {
        "text": "Enter Date",
        "keyboardtype": TextInputType.datetime,
        "obscuretext": false,
        "Controller": dobController,
        "prefixIcon": false,
        "suffixIcon": false,
        "textColor ": const Color(0xffA0A0A0),
      },
      {
        "text": "Enter Weight",
        "keyboardtype": TextInputType.text,
        "obscuretext": false,
        "Controller": weightController,
        "prefixIcon": false,
        "suffixIcon": false,
        "textColor ": const Color(0xffA0A0A0),
      },
    ];
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _getImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _getImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 70,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error picking image: $e';
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dobController.text = picked.toString().split(' ')[0];
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedSpecies == null) {
      setState(() => _errorMessage = 'Please select pet species');
      return;
    }
    if (selectedBreed == null) {
      setState(() => _errorMessage = 'Please select pet breed');
      return;
    }
    if (selectedGender == null) {
      setState(() => _errorMessage = 'Please select pet gender');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userId = await UserService.getUserId();
      if (userId == null) {
        throw Exception('User not logged in');
      }

      String? imageUrl;
      if (_selectedImage != null) {
        imageUrl = await ApiService.uploadImage(_selectedImage!);
        if (imageUrl == null) {
          throw Exception('Failed to upload image');
        }
      }

      final petData = {
        'ownerId': userId,
        'petId': 'pet456',
        'allergies': "None",
        'name': nameController.text.trim(),
        'birthDate': dobController.text,
        'species': selectedSpecies,
        'breed': selectedBreed,
        'weight': double.tryParse(weightController.text) ?? 0,
        'gender': selectedGender,
        if (imageUrl != null) 'imageUrl': imageUrl,
      };

      final response = await ApiService.createPetProfile(petData);
      if (response.statusCode == 201) {
        if (mounted) {
          Navigator.pop(context, true);
        }
      } else {
        throw Exception('Failed to create pet profile');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffF6F6F6),
        body: Form(
          key: _formKey,
          child: Stack(
            children: [
              Positioned(
                left: screenWidth * 0.5,
                top: -screenHeight * 0.4,
                child: Container(
                  width: screenWidth,
                  height: screenHeight * 0.5,
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
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: screenHeight,
                    child: Column(
                      children: [
                        // START APP BAR
                        Row(
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.arrow_back_ios_new),
                            ),
                            SizedBox(width: screenWidth * 0.27),
                            const Text(
                              'My Pets',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: 'Poppins3',
                                letterSpacing: 1.20,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.0125),
                        Container(
                          height: 1,
                          width: screenWidth,
                          color: const Color(0xffD9D9D9),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        // Pet Image Selection
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: screenWidth * 0.1944,
                            height: screenWidth * 0.1944,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: const Color(0xffA0A0A0),
                            ),
                            child: Center(
                              child: Stack(
                                children: [
                                  if (_selectedImage != null)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.file(
                                        _selectedImage!,
                                        width: screenWidth * 0.1944,
                                        height: screenWidth * 0.1944,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  else
                                    Icon(
                                      Icons.person,
                                      size: screenWidth * 0.1944,
                                      color: Colors.white,
                                    ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      height: 25,
                                      width: 25,
                                      decoration: BoxDecoration(
                                        color: const Color(0xffD9D9D9),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        size: 17,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (_errorMessage != null)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Pet's Name",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'poppins1',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 1.12,
                                ),
                              ),
                              CustomTextFormField(
                                hintText: fields[0]["text"],
                                keyboardType: fields[0]["keyboardtype"],
                                controller: fields[0]["Controller"],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter pet's name";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              const Text(
                                "Pet's Date of Birth",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'poppins1',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 1.12,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _selectDate(context),
                                child: AbsorbPointer(
                                  child: CustomTextFormField(
                                    hintText: fields[1]["text"],
                                    keyboardType: fields[1]["keyboardtype"],
                                    controller: fields[1]["Controller"],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please select pet's date of birth";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              const Text("Pet's Species"),
                              SizedBox(height: screenHeight * 0.01),
                              CustomDropdownField<String>(
                                hintText: "Select Pet's Species",
                                value: selectedSpecies,
                                items: speciesList
                                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                    .toList(),
                                onChanged: (val) => setState(() => selectedSpecies = val),
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              const Text("Pet's Breed"),
                              SizedBox(height: screenHeight * 0.01),
                              CustomDropdownField<String>(
                                hintText: "Select Pet's Breed",
                                value: selectedBreed,
                                items: breedList
                                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                    .toList(),
                                onChanged: (val) => setState(() => selectedBreed = val),
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              const Text(
                                "Pet's Weight",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'poppins1',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 1.12,
                                ),
                              ),
                              CustomTextFormField(
                                hintText: fields[2]["text"],
                                keyboardType: TextInputType.number,
                                controller: fields[2]["Controller"],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter pet's weight";
                                  }
                                  if (double.tryParse(value) == null) {
                                    return "Please enter a valid number";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              const Text(
                                "Pet's Gender",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'poppins1',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 1.12,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Row(
                                children: [
                                  GenderSelectorButton(
                                    gender: "Male",
                                    selectedGender: selectedGender ?? "",
                                    icon: Icons.male,
                                    onTap: () => setState(() => selectedGender = "Male"),
                                  ),
                                  SizedBox(width: screenWidth * 0.02),
                                  GenderSelectorButton(
                                    gender: "Female",
                                    selectedGender: selectedGender ?? "",
                                    icon: Icons.female,
                                    onTap: () => setState(() => selectedGender = "Female"),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.03),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xff000000).withOpacity(0.25),
                                        offset: const Offset(0, 4),
                                        blurRadius: 4,
                                      ),
                                      BoxShadow(
                                        color: const Color(0xff99DDCC),
                                        offset: const Offset(0, 0),
                                        blurRadius: 20,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(43),
                                  ),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff99DDCC),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: screenHeight * 0.016,
                                        horizontal: screenWidth * 0.1,
                                      ),
                                    ),
                                    onPressed: _isLoading ? null : _submitForm,
                                    child: _isLoading
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
                                              fontFamily: 'poppins1',
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 2.72,
                                            ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

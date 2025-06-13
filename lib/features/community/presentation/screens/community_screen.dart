import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:petscare/core/presentation/widgets/custom_list_view.dart';
import 'package:petscare/api/api_service.dart';
import 'package:petscare/api/user_service.dart';
import 'package:image_picker/image_picker.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final TextEditingController _postController = TextEditingController();
  List<Map<String, dynamic>> posts = [];
  bool isLoading = true;
  String? userName;
  String? userId;
  List<File> selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadPosts();
  }

  Future<void> _loadUserData() async {
    userName = await UserService.getUserName();
    userId = await UserService.getUserId();
    if (mounted) setState(() {});
  }

  Future<void> _loadPosts() async {
    try {
      setState(() => isLoading = true);
      final response = await ApiService.getCommunityPosts();
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          posts = List<Map<String, dynamic>>.from(data);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading posts: $e')),
        );
      }
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      return await ApiService.uploadImage(imageFile);
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 70,
      );
      
      if (image != null) {
        setState(() {
          selectedImages.add(File(image.path));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _createPost() async {
    if (_postController.text.trim().isEmpty && selectedImages.isEmpty) return;

    try {
      // Upload images and get URLs
      List<String> imageUrls = [];
      for (var image in selectedImages) {
        final url = await _uploadImage(image);
        if (url != null) {
          imageUrls.add(url);
        }
      }
      
      final response = await ApiService.createCommunityPost({
        'userId': userId,
        'username': userName,
        'content': _postController.text.trim(),
        if (imageUrls.isNotEmpty) 'imageUrl': imageUrls.join(','),
      });

      if (response.statusCode == 201) {
        _postController.clear();
        setState(() {
          selectedImages.clear();
        });
        _loadPosts(); // Reload posts after creating new one
      } else {
        throw Exception('Failed to create post');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating post: $e')),
        );
      }
    }
  }

  void _showImagePickerOptions() {
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
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffF6F6F6),
        body: Stack(
          children: [
            Positioned(
              left: size.width * 0.5,
              top: -size.height * 0.4,
              child: Container(
                width: size.width,
                height: size.height * 0.5,
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
            RefreshIndicator(
              onRefresh: _loadPosts,
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05,
                      vertical: size.height * 0.02,
                    ),
                    child: Column(
                      children: [
                        // User input section
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: size.width * 0.12,
                              height: size.width * 0.12,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: const Color(0xffD9DEDF),
                              ),
                              child: Icon(
                                Icons.person,
                                size: size.width * 0.08,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: size.width * 0.03),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userName ?? "Loading...",
                                    style: TextStyle(
                                      color: const Color(0xFF222222),
                                      fontSize: size.width * 0.035,
                                      fontFamily: 'poppins2',
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.69,
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _postController,
                                    maxLines: null,
                                    decoration: const InputDecoration(
                                      hintText: "What's New?",
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      isDense: true,
                                      border: InputBorder.none,
                                    ),
                                  ),
                                  if (selectedImages.isNotEmpty)
                                    Container(
                                      height: size.height * 0.12,
                                      margin: EdgeInsets.only(top: size.height * 0.01),
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: selectedImages.length,
                                        itemBuilder: (context, index) {
                                          return Stack(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(right: size.width * 0.02),
                                                width: size.width * 0.2,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  image: DecorationImage(
                                                    image: FileImage(selectedImages[index]),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 4,
                                                right: 4,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedImages.removeAt(index);
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black.withOpacity(0.5),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const Icon(
                                                      Icons.close,
                                                      size: 16,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.01),
                        // Action buttons
                        Row(
                          children: [
                            SizedBox(width: size.width * 0.15),
                            IconButton(
                              onPressed: () => _showImagePickerOptions(),
                              icon: SvgPicture.asset(
                                'assets/icons/fluent_image.svg',
                                width: size.width * 0.06,
                                height: size.width * 0.06,
                                colorFilter: const ColorFilter.mode(
                                  Color(0xffA0A0A0),
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => _pickImage(ImageSource.camera),
                              icon: SvgPicture.asset(
                                'assets/icons/solar_camera-outline.svg',
                                width: size.width * 0.06,
                                height: size.width * 0.06,
                                colorFilter: const ColorFilter.mode(
                                  Color(0xffA0A0A0),
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: _createPost,
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xff99DDCC),
                                padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.04,
                                  vertical: size.height * 0.01,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                'Post',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.width * 0.04,
                                  fontFamily: 'poppins2',
                                ),
                              ),
                            ),
                            SizedBox(width: size.width * 0.04),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    color: const Color(0xffD9D9D9),
                  ),
                  if (isLoading)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(size.width * 0.05),
                        child: const CircularProgressIndicator(
                          color: Color(0xff99DDCC),
                        ),
                      ),
                    )
                  else if (posts.isEmpty)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(size.width * 0.05),
                        child: Text(
                          'No posts yet. Be the first to post!',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: size.width * 0.04,
                            fontFamily: 'poppins1',
                          ),
                        ),
                      ),
                    )
                  else
                    ...posts.map((post) {
                      final imageUrls = post['imageUrl']?.toString().split(',') ?? [];
                      return CustomListView(
                        usernamedb: post['username'] ?? 'Unknown',
                        textPost: post['content'] ?? '',
                        image1: imageUrls.isNotEmpty ? imageUrls[0] : null,
                        image2: imageUrls.length > 1 ? imageUrls[1] : null,
                        image3: imageUrls.length > 2 ? imageUrls[2] : null,
                      );
                    }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

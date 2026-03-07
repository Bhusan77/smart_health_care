import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_health_care/core/api/api_endpoints.dart';
import 'package:smart_health_care/core/services/storage/user_session_service.dart';
import 'package:smart_health_care/core/utils/snackbar_utils.dart';
import 'package:smart_health_care/features/dashboard/presentation/state/profile_state.dart';
import 'package:smart_health_care/features/dashboard/presentation/view_models/profile_view_model.dart';
import 'package:smart_health_care/features/profile/presentation/widgets/media_picker_bottom_sheet.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final Color primaryOrange = const Color.fromARGB(255, 93, 187, 245);
  final Color lightYellow = const Color.fromARGB(255, 239, 232, 173);
  final Color buttonOrange = const Color(0xFFFFB74D);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();

  final List<XFile?> _profile = [];
  final ImagePicker _imagePicker = ImagePicker();

  String? _profilePicture;
  bool _isDataLoaded = false;
  bool _isSubmitting = false;

  ProviderSubscription<ProfileState>? _profileListener;

  @override
  void initState() {
    super.initState();

    _profileListener = ref.listenManual<ProfileState>(
      profileViewModelProvider,
      (previous, next) {
        if (next.status == ProfileStatus.loaded &&
            !_isDataLoaded &&
            next.user != null) {
          setState(() {
            _isDataLoaded = true;
            _usernameController.text = next.user!.username ?? '';
            _profilePicture = next.user!.profilePicture;
          });
        } else if (next.status == ProfileStatus.updated) {
          setState(() {
            _isSubmitting = false;
          });

          SnackbarUtils.showSuccess(context, 'Profile updated successfully!');
          Navigator.pop(context, true);
        } else if (next.status == ProfileStatus.error) {
          setState(() {
            _isSubmitting = false;
          });

          SnackbarUtils.showError(
            context,
            next.errorMessage ?? 'Something went wrong',
          );
        }
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  Future<void> _loadUserData() async {
    final userSession = ref.read(userSessionServiceProvider);
    final userId = userSession.getCurrentUserId();

    debugPrint("My user id: $userId");

    if (userId != null && userId.isNotEmpty) {
      await ref.read(profileViewModelProvider.notifier).getProfileById(
            userId: userId,
          );
    }
  }

  @override
  void dispose() {
    _profileListener?.close();
    _usernameController.dispose();
    super.dispose();
  }

  Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.status;

    if (status.isGranted) return true;

    if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }

    return false;
  }

  Future<void> _pickFromCamera() async {
    final hasPermission = await _requestPermission(Permission.camera);
    if (!hasPermission) return;

    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (photo != null) {
      setState(() {
        _profile.clear();
        _profile.add(photo);
        _profilePicture = null;
      });
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      Permission permission = Permission.photos;

      if (Platform.isAndroid) {
        permission = Permission.storage;
      }

      final hasPermission = await _requestPermission(permission);
      if (!hasPermission) return;

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _profile.clear();
          _profile.add(image);
          _profilePicture = null;
        });
      }
    } catch (e) {
      debugPrint('Image picker error: $e');
      if (mounted) {
        SnackbarUtils.showError(context, 'Failed to pick image');
      }
    }
  }

  void _showMediaPicker() {
    MediaPickerBottomSheet.show(
      context,
      onCameraTap: _pickFromCamera,
      onGalleryTap: _pickFromGallery,
    );
  }

  void _clearImage() {
    setState(() {
      _profile.clear();
      _profilePicture = null;
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    debugPrint("Save clicked");
    debugPrint("Username: ${_usernameController.text.trim()}");
    debugPrint(
      "Image: ${_profile.isNotEmpty ? _profile.first!.path : 'no image'}",
    );

    await ref.read(profileViewModelProvider.notifier).updateProfile(
          username: _usernameController.text.trim(),
          profile: _profile.isNotEmpty ? File(_profile.first!.path) : null,
        );
  }

  String _buildProfileImageUrl(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    final base = ApiEndpoints.baseUrl.endsWith('/')
        ? ApiEndpoints.baseUrl.substring(0, ApiEndpoints.baseUrl.length - 1)
        : ApiEndpoints.baseUrl;

    final imagePath = path.startsWith('/') ? path : '/$path';

    return '$base$imagePath';
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileViewModelProvider);

    return Scaffold(
      backgroundColor: lightYellow,
      appBar: AppBar(
        backgroundColor: primaryOrange,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: profileState.status == ProfileStatus.loading && !_isDataLoaded
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      if (_profile.isNotEmpty)
                        GestureDetector(
                          onTap: _showMediaPicker,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.pink.shade300,
                                backgroundImage:
                                    FileImage(File(_profile.first!.path)),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: _clearImage,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (_profilePicture != null &&
                          _profilePicture!.trim().isNotEmpty)
                        GestureDetector(
                          onTap: _showMediaPicker,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.pink.shade300,
                                backgroundImage: NetworkImage(
                                  _buildProfileImageUrl(_profilePicture!),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: _clearImage,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        GestureDetector(
                          onTap: _showMediaPicker,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.pink.shade300,
                            child: const Icon(
                              Icons.camera_alt,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),

                      const SizedBox(height: 30),

                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _inputField(
                              controller: _usernameController,
                              label: 'Username',
                              icon: Icons.person_outline,
                              hint: 'Change username',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonOrange,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: _isSubmitting ? null : _handleSubmit,
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: primaryOrange),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                              color: primaryOrange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _inputField({
    required String label,
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Username is required';
            }
            if (value.trim().length < 3) {
              return 'Username must be at least 3 characters';
            }
            return null;
          },
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: const Color.fromARGB(255, 226, 161, 64),
            ),
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFFFFDE7),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
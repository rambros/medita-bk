import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lms_app/models/user_model.dart';
import 'package:lms_app/services/firebase_service.dart';
import 'package:lms_app/theme/theme_provider.dart';
import 'package:lms_app/utils/snackbars.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../components/user_avatar.dart';
import '../constants/custom_colors.dart';
import '../providers/user_data_provider.dart';

class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({super.key, required this.user});

  final UserModel user;

  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  var nameCtlr = TextEditingController();
  final _btnController = RoundedLoadingButtonController();
  final formKey = GlobalKey<FormState>();
  XFile? _selectedImageFile;
  String? _imageUrl;

  @override
  void initState() {
    nameCtlr.text = widget.user.name;
    _imageUrl = widget.user.imageUrl;
    super.initState();
  }

  Future _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);
    if (image != null) {
      _selectedImageFile = image;
      setState(() {});
    }
  }

  Future<String?> _getUserImage() async {
    if (_selectedImageFile != null) {
      final String? imageUrl = await FirebaseService().uploadImageToHosting(_selectedImageFile!);
      return imageUrl;
    } else {
      return widget.user.imageUrl;
    }
  }

  UserModel _userData(String? imageUrl) {
    UserModel userModel = UserModel(
      id: widget.user.id,
      email: widget.user.email,
      name: nameCtlr.text,
      imageUrl: imageUrl,
      updatedAt: DateTime.now().toUtc(),
    );
    return userModel;
  }

  _handleUpdate() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      _btnController.start();
      final String? imageUrl = await _getUserImage();
      await FirebaseService().updateUserProfile(_userData(imageUrl));
      await ref.read(userDataProvider.notifier).getData();
      _btnController.reset();
      setState(() => _selectedImageFile = null);
      if (!mounted) return;
      openSnackbar(context, 'Profile updated');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
      ),
      bottomNavigationBar: BottomAppBar(
        child: RoundedLoadingButton(
          controller: _btnController,
          elevation: 0,
          animateOnTap: false,
          color: Theme.of(context).primaryColor,
          child: Text(
            'update',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
          ).tr(),
          onPressed: () => _handleUpdate(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => _pickImage(),
                child: Center(
                  child: UserAvatar(
                    imageUrl: _imageUrl,
                    imageFile: _selectedImageFile,
                    iconSize: 40,
                    radius: 120,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text('name').tr(),
              const SizedBox(
                height: 10,
              ),
              Container(
                color: isDarkMode ? CustomColor.containerDark : CustomColor.container,
                child: TextFormField(
                  controller: nameCtlr,
                  decoration: InputDecoration(
                    hintText: 'enter-name'.tr(),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) return 'Name is required';
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

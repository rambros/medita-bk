import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, this.imageUrl, this.imageFile, this.iconSize, this.radius});

  final String? imageUrl;
  final XFile? imageFile;
  final double? iconSize;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: radius ?? 30,
      width: radius ?? 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade300,
        image: imageFile != null
            ? DecorationImage(image: FileImage(File(imageFile!.path)), fit: BoxFit.cover)
            : imageUrl != null
                ? DecorationImage(image: CachedNetworkImageProvider(imageUrl!), fit: BoxFit.cover)
                : null,
      ),
      child: Visibility(
        visible: imageUrl == null && imageFile == null,
        child: Icon(
          LineIcons.user,
          size: iconSize ?? 18,
        ),
      ),
    );
  }
}

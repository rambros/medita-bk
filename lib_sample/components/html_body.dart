import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/constants/custom_colors.dart';
import 'package:lms_app/theme/theme_provider.dart';

import '../services/app_service.dart';
import '../utils/image_preview.dart';
import '../utils/next_screen.dart';
import 'video_player_widget.dart';

class HtmlBody extends ConsumerWidget {
  const HtmlBody({
    super.key,
    required this.description,
    this.fontSize,
  });

  final String description;
  final double? fontSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    return Html(
      data: description,
      shrinkWrap: true,
      onLinkTap: (url, _, __) {
        AppService().openLinkWithCustomTab(url!);
      },
      style: {
        "body": Style(
          padding: HtmlPaddings.only(bottom: 20),
          margin: Margins.zero,
          lineHeight: const LineHeight(1.8),
          whiteSpace: WhiteSpace.normal,
          fontSize: FontSize(fontSize ?? 17),
          color: isDarkMode ? CustomColor.paragraphColorDark : CustomColor.paragraphColor,
          fontWeight: FontWeight.w400,
        ),
        "figure, video, div, img": Style(margin: Margins.zero, padding: HtmlPaddings.zero),
        "p": Style(
          padding: AppService.isHTML(description) ? HtmlPaddings.zero : HtmlPaddings.only(left: 20, right: 20, top: 5, bottom: 5),
        ),
        "h1,h2,h3,h4,h5,h6": Style(padding: HtmlPaddings.only(left: 20, right: 20))
      },
      extensions: [
        TagExtension(
          tagsToExtend: {"iframe"},
          builder: (ExtensionContext eContext) {
            final String videoSource = eContext.attributes['src'].toString();
            if (videoSource.contains('youtu') || videoSource.contains('vimeo')) {
              return VideoPlayerWidget(videoUrl: videoSource);
            } 
            return Container();
          },
        ),
        TagExtension(
          tagsToExtend: {"video"},
          builder: (ExtensionContext eContext) {
            final String videoSource = eContext.attributes['src'].toString();
            return VideoPlayerWidget(videoUrl: videoSource);
          },
        ),
        TagExtension(
          tagsToExtend: {"img"},
          builder: (ExtensionContext eContext) {
            String imageUrl = eContext.attributes['src'].toString();
            return InkWell(
              onTap: () => NextScreen.iOS(context, FullImagePreview(imageUrl: imageUrl)),
              child: CachedNetworkImage(imageUrl: imageUrl),
            );
          },
        ),
      ],
    );
  }
}

import 'package:html_unescape/html_unescape.dart';
// ignore: depend_on_referenced_packages
import 'package:html/parser.dart';

extension StringExtension on String {
  String get toNormalText => HtmlUnescape().convert(parse(this).documentElement!.text);
}
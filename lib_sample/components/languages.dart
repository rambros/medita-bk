import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'country_flag.dart';
import '../configs/language_config.dart';

class Languages extends StatefulWidget {
  const Languages({super.key});

  @override
  State<Languages> createState() => _LanguagesState();
}

class _LanguagesState extends State<Languages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('select-language').tr(),
        automaticallyImplyLeading: false,
        titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: 18, fontWeight: FontWeight.w600
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: LanguageConfig.languages.length,
        separatorBuilder: (ctx, index) => const SizedBox(
          height: 15,
        ),
        itemBuilder: (BuildContext context, int index) {
          final Locale currentLocale = context.locale;
          final Locale locale = Locale(
            LanguageConfig.languages.values.elementAt(index).first,
            LanguageConfig.languages.values.elementAt(index).last,
          );
          final String languageName = LanguageConfig.languages.keys.elementAt(index);

          return Container(
            decoration: BoxDecoration(border: Border.all(width: 0.4, color: Colors.blueGrey), borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: CountryFlag(countryCode: locale.countryCode.toString()),
              horizontalTitleGap: 15,
              title: Text(
                languageName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              trailing: Visibility(
                visible: currentLocale == locale,
                child: const Icon(Icons.done, color: Colors.blueAccent),
              ),
              onTap: () async {
                final engine = WidgetsFlutterBinding.ensureInitialized();
                await context.setLocale(locale);
                await engine.performReassemble();
              },
            ),
          );
        },
      ),
    );
  }
}

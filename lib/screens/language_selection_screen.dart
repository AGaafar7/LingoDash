import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lingodash/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  _LanguageSelectionScreenState createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  final List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English', 'nativeName': 'English'},
    {'code': 'ar', 'name': 'Arabic', 'nativeName': 'العربية'},
    {'code': 'es', 'name': 'Spanish', 'nativeName': 'Español'},
    {'code': 'ms', 'name': 'Malay', 'nativeName': 'Bahasa Melayu'},
    {'code': 'de', 'name': 'German', 'nativeName': 'Deutsch'},
    {'code': 'zh', 'name': 'Chinese', 'nativeName': '中文'},
    {'code': 'ja', 'name': 'Japanese', 'nativeName': '日本語'},
    {'code': 'hi', 'name': 'Hindi', 'nativeName': 'हिन्दी'},
    {'code': 'id', 'name': 'Indonesian', 'nativeName': 'Bahasa Indonesia'},
    {'code': 'bn', 'name': 'Bengali', 'nativeName': 'বাংলা'},
    {'code': 'fr', 'name': 'French', 'nativeName': 'Français'},
    {'code': 'pt', 'name': 'Portuguese', 'nativeName': 'Português'},
    {'code': 'ru', 'name': 'Russian', 'nativeName': 'Русский'},
    {'code': 'ko', 'name': 'Korean', 'nativeName': '한국어'},
    {'code': 'tr', 'name': 'Turkish', 'nativeName': 'Türkçe'},
  ];

  String? selectedLanguage;

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
  }

  Future<void> _loadSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage = prefs.getString('language') ?? 'en';
    });
  }

  Future<void> _saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode);
    setState(() {
      selectedLanguage = languageCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.selectLanguage)),
      body: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          final language = languages[index];
          return ListTile(
            leading: Radio<String>(
              value: language['code']!,
              groupValue: selectedLanguage,
              onChanged: (value) {
                if (value != null) {
                  _saveLanguage(value);
                }
              },
            ),
            title: Text(language['name']!),
            subtitle: Text(language['nativeName']!),
            onTap: () {
              _saveLanguage(language['code']!);
              // Using pop instead of push to re-render the HomeScreen with the new language

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          );
        },
      ),
    );
  }
}

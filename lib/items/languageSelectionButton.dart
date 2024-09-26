import 'package:flutter/material.dart';
import '../data/language_provider.dart';
import 'package:provider/provider.dart';

class LanguageSelectionButton extends StatefulWidget {
  final Function() updateAchievements;
  const LanguageSelectionButton({super.key, required this.updateAchievements});

  @override
  _LanguageSelectionButtonState createState() => _LanguageSelectionButtonState();
}

class _LanguageSelectionButtonState extends State<LanguageSelectionButton> {
  Locale? selectedLocale;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Container(
      width: 120,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromRGBO(11, 106, 108, 1.0),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center (
        child:  Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<Locale>(
            value: selectedLocale,
            onChanged: (Locale? newValue) {
              setState(() {
                selectedLocale = newValue;
                widget.updateAchievements();
              });
              languageProvider.changeLanguage(newValue!);
            },
            items: const [
              DropdownMenuItem<Locale>(
                value: Locale('ru'),
                child: Text(
                  'RU',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
              DropdownMenuItem<Locale>(
                value: Locale('pl'),
                child: Text(
                  'PL',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
              DropdownMenuItem<Locale>(
                value: Locale('en'),
                child: Text(
                  'EN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
            hint: Text(
              Localizations.localeOf(context).languageCode.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            isExpanded: false,
            underline: const SizedBox(),
            style: const TextStyle(fontSize: 16.0),
            selectedItemBuilder: (BuildContext context) {
              return [
                const DropdownMenuItem<Locale>(
                  value: Locale('ru'),
                  child: Text(
                    'RU',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                const DropdownMenuItem<Locale>(
                  value: Locale('pl'),
                  child: Text(
                    'PL',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                const DropdownMenuItem<Locale>(
                  value: Locale('en'),
                  child: Text(
                    'EN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ];
            },
          ),
        ),
      ),
    );
  }
}
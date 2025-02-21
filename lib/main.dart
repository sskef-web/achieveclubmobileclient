import 'package:achieveclubmobileclient/pages/Payment_Required_Page.dart';

import 'pages/Authentication_Page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'data/Language_Provider.dart';
import 'package:backdoor_flutter/backdoor_flutter.dart';
import 'dart:developer';

String baseURL = 'https://achieve.by:5001/';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await BackdoorFlutter.init(
    jsonUrl: "https://sskef-web.github.io/achieveclub_door/info.json",
    appName: "achieve_client",
    version: 1,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isAppPaid = false;

  @override
  void initState() {
    super.initState();
    _checkPaymentStatus();
  }

  void _checkPaymentStatus() {
    BackdoorFlutter.checkStatus(
      onException: (exception) {
        log(exception.toString(), name: "onException");
      },
      onUnhandled: (reason, backdoorPaymentModel) {
        log(reason.name, name: "onUnhandled");
        log(backdoorPaymentModel.toString(), name: "onUnhandled");
      },
      onAppNotFound: () {
        log("onAppNotFound", name: "onAppNotFound");
      },
      onLimitedLaunch: (backdoorPaymentModel, currentCount) {
        log(currentCount.toString(), name: "onLimitedLaunch");
        log(backdoorPaymentModel.toString(), name: "onLimitedLaunch");
      },
      onLimitedLaunchExceeded: (backdoorPaymentModel) {
        log(backdoorPaymentModel.toString(), name: "onLimitedLaunchExceeded");
      },
      onPaid: (backdoorPaymentModel) {
        log(backdoorPaymentModel.toString(), name: "onPaid");
        setState(() {
          isAppPaid = false;
        });
      },
      onTargetVersionMisMatch: (backdoorPaymentModel, targetVersion, configuredVersion) {
        log(backdoorPaymentModel.toString(), name: "onTargetVersionMisMatch");
        log(targetVersion.toString(), name: "onTargetVersionMisMatch Target Version");
        log(configuredVersion.toString(), name: "onTargetVersionMisMatch Configured Version");
      },
      onTrial: (backdoorPaymentModel, expiryDate, warningDate) {
        log(backdoorPaymentModel.toString(), name: "onTrial");
        log(expiryDate.toString(), name: "onTrial expiryDate");
        log(warningDate.toString(), name: "onTrial warningDate");
      },
      onTrialEnded: (backdoorPaymentModel, expiryDate) {
        log(backdoorPaymentModel.toString(), name: "onTrialEnded");
        log(expiryDate.toString(), name: "onTrialEnded expiryDate");
      },
      onTrialWarning: (backdoorPaymentModel, expiryDate, warningDate) {
        log(backdoorPaymentModel.toString(), name: "onTrialWarning");
        log(expiryDate.toString(), name: "onTrialWarning expiryDate");
        log(warningDate.toString(), name: "onTrialWarning warningDate");
      },
      onUnPaid: (backdoorPaymentModel) {
        log(backdoorPaymentModel.toString(), name: "onUnPaid");
        setState(() {
          isAppPaid = true;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LanguageProvider>(
      create: (_) => LanguageProvider(),
      child: Consumer<LanguageProvider>(
        builder: (_, languageProvider, __) {
          return MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ru', ''), // Русский
              Locale('pl', ''), // Польский
              Locale('en', '') // Английский
            ],
            locale: languageProvider.locale,
            theme: ThemeData(
              colorScheme: ColorScheme.light(
                primary: Color.fromRGBO(245, 110, 15, 1),
                onError: Color.fromRGBO(251, 251, 251, 1),
                surface: Color.fromRGBO(251, 251, 251, 1),
                brightness: Brightness.light,
              ),
              useMaterial3: true,
              fontFamily: 'Exo2',
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.dark(
                primary: Color.fromRGBO(245, 110, 15, 1),
                onError: Colors.white,
                surface: Color.fromRGBO(27, 26, 31, 1),
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
              fontFamily: 'Exo2',
            ),
            home: isAppPaid ? const AuthenticationPage() : const PaymentRequiredPage(),
          );
        },
      ),
    );
  }
}

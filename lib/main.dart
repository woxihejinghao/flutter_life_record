import 'package:flutter/material.dart';
import 'package:flutter_life_record/Common/lr_instances.dart';
import 'package:flutter_life_record/Page/ToDo/Pages/todo_home_page.dart';
import 'package:flutter_life_record/Page/ToDo/Providers/providers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initNotification();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: OKToast(
        textPadding: EdgeInsets.fromLTRB(8, 4, 8, 4),
        radius: 8,
        child: MaterialApp(
          localizationsDelegates: [
            PickerLocalizationsDelegate.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          navigatorKey: LRInstances.navigatorKey,
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: FlexThemeData.light(
            scheme: FlexScheme.blueWhale,
            surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
            blendLevel: 18,
            appBarStyle: FlexAppBarStyle.primary,
            appBarOpacity: 0.95,
            appBarElevation: 0,
            transparentStatusBar: true,
            tabBarStyle: FlexTabBarStyle.forAppBar,
            tooltipsMatchBackground: true,
            swapColors: false,
            lightIsWhite: true,
            useSubThemes: true,
            visualDensity: FlexColorScheme.comfortablePlatformDensity,
            // To use playground font, add GoogleFonts package and uncomment:
            // fontFamily: GoogleFonts.notoSans().fontFamily,
            subThemesData: const FlexSubThemesData(
              useTextTheme: true,
              fabUseShape: true,
              interactionEffects: true,
              bottomNavigationBarOpacity: 1,
              bottomNavigationBarElevation: 0,
              inputDecoratorIsFilled: true,
              inputDecoratorBorderType: FlexInputBorderType.outline,
              inputDecoratorUnfocusedHasBorder: true,
              blendOnColors: true,
              blendTextTheme: true,
              popupMenuOpacity: 0.95,
            ),
          ),
          darkTheme: FlexThemeData.dark(
            scheme: FlexScheme.blueWhale,
            surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
            blendLevel: 18,
            appBarStyle: FlexAppBarStyle.background,
            appBarOpacity: 0.95,
            appBarElevation: 0,
            transparentStatusBar: true,
            tabBarStyle: FlexTabBarStyle.forAppBar,
            tooltipsMatchBackground: true,
            swapColors: false,
            darkIsTrueBlack: false,
            useSubThemes: true,
            visualDensity: FlexColorScheme.comfortablePlatformDensity,
            // To use playground font, add GoogleFonts package and uncomment:
            // fontFamily: GoogleFonts.notoSans().fontFamily,
            subThemesData: const FlexSubThemesData(
              useTextTheme: true,
              fabUseShape: true,
              interactionEffects: true,
              bottomNavigationBarOpacity: 1,
              bottomNavigationBarElevation: 0,
              inputDecoratorIsFilled: true,
              inputDecoratorBorderType: FlexInputBorderType.outline,
              inputDecoratorUnfocusedHasBorder: true,
              blendOnColors: true,
              blendTextTheme: true,
              popupMenuOpacity: 0.95,
            ),
          ),
          themeMode: ThemeMode.system,
          home: ToDoHomePage(),
        ),
      ),
    );
  }

  /// 初始化通知
  initNotification() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

//收到通知
  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {}
  //点击通知
  void selectNotification(String? payload) async {}
}

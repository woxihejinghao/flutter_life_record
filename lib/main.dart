import 'package:flutter/material.dart';
import 'package:flutter_life_record/Common/lr_instances.dart';
import 'package:flutter_life_record/Page/ToDo/Pages/todo_home_page.dart';
import 'package:flutter_life_record/Page/ToDo/Providers/providers.dart';
import 'package:flutter_life_record/Page/ToDo/Providers/todo_home_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('settings');
  await _configureLocalTimeZone();
  runApp(MyApp());
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    initNotification();
    //生命周期状态监听
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    //生命周期变化
    if (state == AppLifecycleState.resumed) {
      print("app进入前台");
      //刷新每日行程
      currentContext.read<ToDoHomeProvider>().updateToDayItemList();
    } else if (state == AppLifecycleState.inactive) {
      print("app在前台但是不响应事件，比如电话");
    } else if (state == AppLifecycleState.paused) {
      print("app进入后台");
    } else if (state == AppLifecycleState.detached) {
      print("没有宿主视图但是flutter引擎仍然有效");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: OKToast(
        textPadding: EdgeInsets.fromLTRB(8, 4, 8, 4),
        radius: 8,
        child: MaterialApp(
          navigatorObservers: [routerObserver],
          localizationsDelegates: [
            PickerLocalizationsDelegate.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          navigatorKey: LRInstances.navigatorKey,
          title: '记.念日',
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

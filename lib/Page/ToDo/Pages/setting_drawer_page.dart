import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_life_record/Extension/lr_extesion.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
//通知类型
enum LRNoticeType { morning, noon, night }

class SettingDrawerPage extends StatefulWidget {
  const SettingDrawerPage({Key? key}) : super(key: key);

  @override
  _SettingDrawerPageState createState() => _SettingDrawerPageState();
}

class _SettingDrawerPageState extends State<SettingDrawerPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            ValueListenableBuilder(
                //早上通知
                valueListenable: Hive.box("settings").listenable(),
                builder: (ctx, Box box, child) {
                  return _buildSwitch(
                      "早上通知", box.get("morningNotice", defaultValue: false),
                      (value) {
                    box.put("morningNotice", value);
                    _setNotification(value, LRNoticeType.morning);
                  });
                }),
            ValueListenableBuilder(
                //早上通知
                valueListenable: Hive.box("settings").listenable(),
                builder: (ctx, Box box, child) {
                  return _buildSwitch(
                      "中午通知", box.get("noonNotice", defaultValue: false),
                      (value) {
                    box.put("noonNotice", value);
                    _setNotification(value, LRNoticeType.noon);
                  });
                }),
            ValueListenableBuilder(
                //早上通知
                valueListenable: Hive.box("settings").listenable(),
                builder: (ctx, Box box, child) {
                  return _buildSwitch(
                      "晚上通知", box.get("nightNotice", defaultValue: false),
                      (value) {
                    box.put("nightNotice", value);
                    _setNotification(value, LRNoticeType.night);
                  });
                }),
          ],
        ),
      ),
    );
  }

//头部
  Widget _buildHeader() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      color: context.lrColorScheme.secondary,
      child: Center(
        child: Text(
          "今天事，今天了~",
          style: context.lrTextTheme.headline4!.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSwitch(String title, bool value, ValueChanged? onChange) {
    return Container(
      child: ListTile(
        title: Text(title),
        trailing: CupertinoSwitch(
          value: value,
          onChanged: onChange,
        ),
      ),
    );
  }

  Future<void> _setNotification(bool open, LRNoticeType type) async {
    if (open) {
      Map<String, String> content = _getNoticeContent(type);
      int hour = 20;
      if (type == LRNoticeType.morning) {
        hour = 8;
      } else if (type == LRNoticeType.noon) {
        hour = 12;
      }
      await flutterLocalNotificationsPlugin.zonedSchedule(
          0,
          content["title"],
          content["body"],
          _nextInstance(hour),
          const NotificationDetails(
            android: AndroidNotificationDetails('daily notification channel id',
                'daily notification channel name',
                channelDescription: 'daily notification description'),
          ),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time);
    } else {
      //关闭通知
      flutterLocalNotificationsPlugin.cancel(type.index);
    }
  }

  Map<String, String> _getNoticeContent(LRNoticeType type) {
    switch (type) {
      case LRNoticeType.morning:
        return {"title": "早上好", "body": "快检查一下今天要完成的事情吧～"};
      case LRNoticeType.noon:
        return {"title": "中午好", "body": "跟进一下当前的进度吧～"};
      case LRNoticeType.night:
        return {"title": "晚上好", "body": "快检查一下今天是否都完结了吧～"};
      default:
        return {"title": "快检查一下今天要完成的事情吧～", "body": ""};
    }
  }

  tz.TZDateTime _nextInstance(int hour) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}

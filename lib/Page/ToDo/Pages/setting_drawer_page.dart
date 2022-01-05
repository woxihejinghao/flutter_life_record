import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_life_record/Common/lr_route.dart';
import 'package:flutter_life_record/Extension/lr_extension.dart';
import 'package:flutter_life_record/Page/ToDo/Pages/todo_record_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
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
            ListTile(
              leading: Icon(
                Icons.bar_chart,
                color: Colors.black,
                size: 20,
              ),
              title: Text("记录统计"),
              trailing: Icon(
                Icons.navigate_next,
              ),
              onTap: () {
                Navigator.of(context).pop();
                lrPushPage(ToDoRecordPage());
              },
            ),
            ValueListenableBuilder(
                //早上通知
                valueListenable: Hive.box("settings").listenable(),
                builder: (ctx, Box box, child) {
                  return _buildSwitch("早上通知", box.get("morningNotice", defaultValue: false), (value) {
                    _setNotification(value, LRNoticeType.morning, box);
                  });
                }),
            ValueListenableBuilder(
                //早上通知
                valueListenable: Hive.box("settings").listenable(),
                builder: (ctx, Box box, child) {
                  return _buildSwitch("中午通知", box.get("noonNotice", defaultValue: false), (value) {
                    _setNotification(value, LRNoticeType.noon, box);
                  });
                }),
            ValueListenableBuilder(
                //早上通知
                valueListenable: Hive.box("settings").listenable(),
                builder: (ctx, Box box, child) {
                  return _buildSwitch("晚上通知", box.get("nightNotice", defaultValue: false), (value) {
                    _setNotification(value, LRNoticeType.night, box);
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
        leading: Icon(
          Icons.notifications,
          color: Colors.black,
          size: 20,
        ),
        title: Text(title),
        trailing: CupertinoSwitch(
          value: value,
          onChanged: onChange,
        ),
      ),
    );
  }

  Future<void> _setNotification(bool open, LRNoticeType type, Box<dynamic> box) async {
    if (await Permission.notification.isDenied) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text("是否开启通知？"),
                content: Text("需要打开通知权限，才能正常接收通知。"),
                actions: [
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("取消")),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        openAppSettings();
                      },
                      child: Text("去开启"))
                ],
              ));

      return;
    }
    List names = ["morningNotice", "noonNotice", "nightNotice"];
    box.put(names[type.index], open);
    if (open) {
      Map<String, String> content = _getNoticeContent(type);
      int hour = 20;
      if (type == LRNoticeType.morning) {
        hour = 8;
      } else if (type == LRNoticeType.noon) {
        hour = 15;
      }
      await flutterLocalNotificationsPlugin.zonedSchedule(
          0,
          content["title"],
          content["body"],
          _nextInstance(hour),
          const NotificationDetails(
            android: AndroidNotificationDetails('daily notification channel id', 'daily notification channel name',
                channelDescription: 'daily notification description'),
          ),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
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
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}

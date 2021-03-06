import 'package:flutter/material.dart';
import 'package:flutter_life_record/Common/lr_color.dart';
import 'package:flutter_life_record/Common/lr_instances.dart';
import 'package:flutter_life_record/Common/lr_route.dart';
import 'package:flutter_life_record/Page/ToDo/Pages/todo_list_create_page.dart';
import 'package:flutter_life_record/Page/ToDo/Pages/todo_project_create_page.dart';
import 'package:flutter_life_record/Page/ToDo/Providers/providers.dart';
import 'package:flutter_life_record/Page/ToDo/Providers/todo_home_provider.dart';
import 'package:flutter_life_record/Page/ToDo/Providers/todo_project_details_provider.dart';
import 'package:flutter_life_record/Page/ToDo/Widgets/todo_litst_card.dart';
import 'package:provider/provider.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class ToDoProjectDetailsPage extends StatelessWidget {
  const ToDoProjectDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () => lrPushPage(
              valueProvider(context.read<ToDoProjectDetailsProvider>(),
                  child: ToDoListCreatePage(
                    projectID:
                        context.read<ToDoProjectDetailsProvider>().model.id,
                  ))),
          child: Icon(
            Icons.add,
            size: 25,
          ),
          backgroundColor: LRThemeColor.mainColor),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            actions: [
              _editButtonWidget(context),
            ],
            pinned: true,
            centerTitle: false,
            expandedHeight: 100,
            flexibleSpace: FlexibleSpaceBar(
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                      context
                          .select((ToDoProjectDetailsProvider provider) =>
                              provider.model)
                          .getIconData(),
                      color: HexColor(context
                          .select((ToDoProjectDetailsProvider provider) =>
                              provider.model)
                          .colorHex)),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    context
                        .select((ToDoProjectDetailsProvider provider) =>
                            provider.model)
                        .name,
                    style: TextStyle(
                        color: HexColor(context
                            .select((ToDoProjectDetailsProvider provider) =>
                                provider.model)
                            .colorHex)),
                  )
                ],
              ),
              centerTitle: false,
            ),
          ),
          _buildToDoList(context)
        ],
      ),
    );
  }

//????????????
  SliverList _buildToDoList(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      var model = context.read<ToDoProjectDetailsProvider>().itemList[index];
      return Container(
        padding: EdgeInsets.only(left: 14, right: 14),
        margin: EdgeInsets.only(top: 10),
        child: Dismissible(
            background: _deleteBackgroundWidget(),
            key: ValueKey(model),
            onDismissed: (d) =>
                context.read<ToDoProjectDetailsProvider>().deleteItem(model.id),
            child: ToDoListCard(
              onTap: () => lrPushPage(
                  valueProvider(context.read<ToDoProjectDetailsProvider>(),
                      child: ToDoListCreatePage(
                        model: model,
                      ))),
              model: model,
              isSelected: false,
              finishCallBack: () {
                print("????????????");
                //????????????
                context
                    .read<ToDoProjectDetailsProvider>()
                    .updateItemFinish(model);
              },
            )),
      );
    },
            childCount:
                context.watch<ToDoProjectDetailsProvider>().itemList.length));
  }

  //????????????
  PopupMenuButton<int> _editButtonWidget(BuildContext context) {
    return PopupMenuButton(
      child: Padding(
        padding: EdgeInsets.only(right: 10),
        child: Icon(Icons.edit),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Text("???????????????"),
          value: 0,
        ),
        PopupMenuItem(
          child: Text(
            "????????????",
            style: TextStyle(color: Colors.red),
          ),
          value: 1,
        )
      ],
      onSelected: (index) async {
        if (index == 0) {
          //??????????????????
          lrPushPage(ChangeNotifierProvider.value(
            value: context.read<ToDoProjectDetailsProvider>(),
            child: ToDoProjectCreatePage(
              model: context.read<ToDoProjectDetailsProvider>().model,
            ),
          ));
        } else if (index == 1) {
          //????????????
          await showDialog(
              context: currentContext,
              builder: (context) => AlertDialog(
                    title: Text("??????"),
                    content: Text("???????????????????????????"),
                    actions: [
                      TextButton(
                          onPressed: () => navigatorState.pop(),
                          child: Text(
                            "??????",
                            style:
                                TextStyle(color: LRThemeColor.lightTextColor),
                          )),
                      TextButton(
                          onPressed: () async {
                            await currentContext
                                .read<ToDoHomeProvider>()
                                .deleteProject(currentContext
                                    .read<ToDoProjectDetailsProvider>()
                                    .model
                                    .id);
                            navigatorState.pop();
                          },
                          child: Text(
                            "??????",
                            style: TextStyle(color: LRThemeColor.mainColor),
                          ))
                    ],
                  )).then((value) => navigatorState.pop());
        }
      },
    );
  }

  Padding _deleteBackgroundWidget() {
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              "??????",
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(8))),
      ),
    );
  }
}

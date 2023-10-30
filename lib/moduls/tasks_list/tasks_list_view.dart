import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/network_layer/firestore_utils.dart';
import 'package:todo_app/core/theme/app_theme.dart';
import 'package:todo_app/moduls/tasks_list/widgets/task_item_widget.dart';

import '../../provider/settings_provider.dart';

class TasksListView extends StatefulWidget {
  const TasksListView({super.key});

  @override
  State<TasksListView> createState() => _TasksListViewState();
}

class _TasksListViewState extends State<TasksListView> {
  //List<TaskModel> allTasks = [];

  DateTime selectedDate = DateTime.now();

  /*@override
  void initState() {
    loadTask();
    super.initState();
  }*/

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SettingsProvider>(context);
    var mediaQuery = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 40, left: 20),
          width: mediaQuery.width,
          height: mediaQuery.height * 0.15,
          color: AppTheme.primaryColor,
          child: Text(
            AppLocalizations.of(context)!.todolist,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        CalendarTimeline(
          initialDate: selectedDate,
          firstDate: DateTime.now().subtract(Duration(days: 30)),
          lastDate: DateTime.now().add(Duration(days: 365)),
          onDateSelected: (date) {
            selectedDate = date;
            setState(() {});
          },
          leftMargin: 20,
          monthColor: provider.isDark() ? Colors.white : Colors.black,
          dayColor: provider.isDark() ? Colors.white : Colors.black,
          activeDayColor:
              provider.isDark() ? Colors.white : AppTheme.primaryColor,
          activeBackgroundDayColor:
              provider.isDark() ? Color(0xFF141922) : Colors.white,
          dotsColor: provider.isDark() ? Colors.white : AppTheme.primaryColor,
        ),
        Expanded(
          child: StreamBuilder(
            stream: FirestoreUtils.getRealTimeDataFromFirestore(selectedDate),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
                return Text('Error Eccoured');
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                  ),
                );
              }
              var tasksList = snapshot.data?.docs.map((e) => e.data()).toList();
              return ListView.builder(
                padding: EdgeInsets.only(
                  top: 10,
                ),
                itemBuilder: (context, index) => TaskItemWidget(
                  model: tasksList![index],
                  // title: tasksList?[index].title ?? '',
                  // description: tasksList?[index].description ?? '',
                ),
                itemCount: tasksList?.length ?? 0,
              );
            },
          ),
        ),
        /*Expanded(
          child: FutureBuilder<List<TaskModel>>(
            future: FirestoreUtils.getDataFromFirestore(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error Eccoured');
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                  ),
                );
              }
              var tasksList = snapshot.data;
              return ListView.builder(
                padding: EdgeInsets.only(
                  top: 10,
                ),
                itemBuilder: (context, index) => TaskItemWidget(
                  title: tasksList?[index].title ?? '',
                  description: tasksList?[index].description ?? '',
                ),
                itemCount: tasksList?.length ?? 0,
              );
            },
          ),
        ),*/
        /*Expanded(
          child: ListView.builder(
            padding: EdgeInsets.only(
              top: 10,
            ),
            itemBuilder: (context, index) => TaskItemWidget(
              title: allTasks[index].title ?? '',
              description: allTasks[index].description ?? '',
            ),
            itemCount: allTasks.length,
          ),
        ),*/
      ],
    );
  }

/*loadTask(){
    FirestoreUtils.getDataFromFirestore().then((value) {
      setState(() {
        allTasks = value;
      });
    });
  }*/
}

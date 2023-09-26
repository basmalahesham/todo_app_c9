import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/network_layer/firestore_utils.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/moduls/edit/edit_screen.dart';

import '../../../core/theme/app_theme.dart';
import '../../../provider/settings_provider.dart';

class TaskItemWidget extends StatefulWidget {
  final TaskModel model;

  // final String title;
  // final String description;
  TaskItemWidget({super.key, required this.model});

  @override
  State<TaskItemWidget> createState() => _TaskItemWidgetState();
}

class _TaskItemWidgetState extends State<TaskItemWidget> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SettingsProvider>(context);
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      /*decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(15),
      ),*/
      child: Slidable(
        startActionPane: ActionPane(
          extentRatio: 0.4,
          motion: DrawerMotion(),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                topLeft: Radius.circular(15),
              ),
              onPressed: (context) {
                FirestoreUtils.deleteData(widget.model);
              },
              backgroundColor: Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
            SlidableAction(
                // borderRadius: BorderRadius.circular(15),
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                icon: Icons.edit,
                label: 'Edit',
                onPressed: (context) {
                  Navigator.pushNamed(context, EditScreen.routeName,
                      arguments: widget.model);
                }),
          ],
        ),
        child: Container(
          // margin: const EdgeInsets.symmetric(
          //   horizontal: 15,
          //   vertical: 8,
          // ),
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 20,
          ),
          decoration: BoxDecoration(
            color: provider.isDark() ? Color(0xFF141922) : Colors.white,
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 4,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: widget.model.isDone!
                      ? Colors.green
                      : AppTheme.primaryColor,
                ),
              ),
              const SizedBox(
                width: 25,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.model.title ?? '',
                    style: GoogleFonts.poppins(
                      color: widget.model.isDone!
                          ? Colors.green
                          : AppTheme.primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.model.description ?? '',
                    style: GoogleFonts.poppins(
                      color: provider.isDark() ? Colors.white : Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: 20,
                        color: provider.isDark() ? Colors.white : Colors.black,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        widget.model.dateTime.toString(),
                        style: GoogleFonts.roboto(
                          color:
                              provider.isDark() ? Colors.white : Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  FirestoreUtils.isDoneTask(widget.model);
                  setState(() {});
                },
                child: widget.model.isDone!
                    ? Text(
                        'Done!',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppTheme.primaryColor,
                        ),
                        child: Icon(
                          Icons.check,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

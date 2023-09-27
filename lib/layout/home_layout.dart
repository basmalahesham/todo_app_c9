import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/theme/app_theme.dart';
import 'package:todo_app/layout/widgets/show_add_task_bottom_sheet.dart';
import 'package:todo_app/moduls/settings/settings_view.dart';
import 'package:todo_app/moduls/tasks_list/tasks_list_view.dart';

import '../provider/settings_provider.dart';

class HomeLayoutView extends StatefulWidget {
  static const String routeName = 'home_layout';

  const HomeLayoutView({super.key});

  @override
  State<HomeLayoutView> createState() => _HomeLayoutViewState();
}

class _HomeLayoutViewState extends State<HomeLayoutView> {
  DateTime selectedDate = DateTime.now();
  int selectedIndex = 0;
  List<Widget> screens = [
    const TasksListView(),
    const SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SettingsProvider>(context);
    return Scaffold(
      body: screens[selectedIndex],
      /*appBar: AppBar(
        title: Text(
          'To Do List',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),*/
      extendBody: true,
      floatingActionButton: Container(
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: FloatingActionButton(
          backgroundColor: AppTheme.primaryColor,
          onPressed: () {
            ShowAddTasksBottomSheet();
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: provider.isDark() ? Color(0xFF141922) : Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (int index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "settings"),
          ],
        ),
      ),
    );
  }

  ShowAddTasksBottomSheet() {
    showModalBottomSheet(
      context: context,
      //isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => AddTaskBottomSheet(),
    );
  }
}

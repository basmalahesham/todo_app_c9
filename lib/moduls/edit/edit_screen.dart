import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/network_layer/firestore_utils.dart';

import '../../core/theme/app_theme.dart';
import '../../models/task_model.dart';
import '../../provider/settings_provider.dart';

class EditScreen extends StatefulWidget {
  EditScreen({
    super.key,
  });

  static const String routeName = 'edit_screen';

  // final TaskModel model;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SettingsProvider>(context);
    var mediaQuery = MediaQuery.of(context).size;
    var args = ModalRoute.of(context)!.settings.arguments as TaskModel;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 40, left: 20),
            width: mediaQuery.width,
            height: mediaQuery.height * 0.15,
            color: AppTheme.primaryColor,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.todolist,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            height: mediaQuery.height * 0.7,
            decoration: BoxDecoration(
              color: provider.isDark() ? Color(0xFF141922) : Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppLocalizations.of(context)!.editTasks,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: provider.isDark() ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(
                  height: mediaQuery.height * 0.002,
                ),
                Text(
                  "Title",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: provider.isDark() ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(
                  height: mediaQuery.height * 0.01,
                ),
                TextFormField(
                  initialValue: args.title,
                  onChanged: (value) {
                    args.title = value;
                  },
                  //controller: titleController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Title can't be empty";
                    } else if (value.length < 8) {
                      return "Title must be at least 8 characters";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    /*labelText: 'Title',
                labelStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),*/
                    hintText: 'Enter Your Task Title',
                    hintStyle: TextStyle(
                      color: provider.isDark() ? Colors.white : Colors.black,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: mediaQuery.height * 0.01,
                ),
                Text(
                  "Description",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: provider.isDark() ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(
                  height: mediaQuery.height * 0.01,
                ),
                TextFormField(
                  initialValue: args.description,
                  onChanged: (value) {
                    args.description = value;
                  },
                  //controller: descriptionController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Description can't be empty";
                    } else {
                      return null;
                    }
                  },
                  minLines: 3,
                  maxLines: 3,
                  decoration: InputDecoration(
                    /*labelText: 'Description',
                labelStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),*/
                    hintText: 'Enter Your Task Description',
                    hintStyle: TextStyle(
                      color: provider.isDark() ? Colors.white : Colors.black,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: mediaQuery.height * 0.01,
                ),
                Text(
                  "Select Time",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: provider.isDark() ? Colors.white : Colors.black,
                  ),
                ),
                /*InkWell(
                  onTap: () {
                    selectDateTime();
                  },
                  child: Text(
                    (DateFormat.yMMMEd().format(selectedDate)),
                    //"${selectedDate.day} - ${selectedDate.month} - ${selectedDate.year}",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),*/
                InkWell(
                  onTap: () async {
                    selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.fromMillisecondsSinceEpoch(
                                args.dateTime!),
                            firstDate: DateTime.now(),
                            lastDate:
                                DateTime.now().add(Duration(days: 365))) ??
                        DateTime.now();
                    setState(() {
                      args.dateTime = selectedDate.millisecondsSinceEpoch;
                    });
                  },
                  child: Text(
                    (DateFormat.yMMMEd().format(selectedDate)),
                    //"${selectedDate.day} - ${selectedDate.month} - ${selectedDate.year}",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: mediaQuery.height * 0.08,
                ),
                ElevatedButton(
                  onPressed: () {
                    FirestoreUtils.updateTask(args);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    "Save Changes",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

/*selectDateTime() async {
    // select date
    // day month year
    var currentDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
    );
    if (currentDate == null) {
      return;
    }
    selectedDate = currentDate;
    setState(() {});
  }*/
}

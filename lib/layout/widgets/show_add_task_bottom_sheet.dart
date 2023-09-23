import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/core/theme/app_theme.dart';

import '../../core/network_layer/firestore_utils.dart';
import '../../core/services/snackbar_service.dart';
import '../../models/task_model.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  var formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  //TextEditingController dueDateController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Add New Task",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Title",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: titleController,
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
                  hintText: 'Enter Your Task Title',
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
              const SizedBox(
                height: 10,
              ),
              Text(
                "Description",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: descriptionController,
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
                  hintText: 'Enter Your Task Description',
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
              const SizedBox(
                height: 5,
              ),
              Text(
                "Select Time",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              InkWell(
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
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  addTask();
                },
                child: Text(
                  "Add Task",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  selectDateTime() async {
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
  }

  void addTask() async {
    if (formKey.currentState!.validate()) {
      TaskModel taskModel = TaskModel(
        title: titleController.text,
        description: descriptionController.text,
        isDone: false,
        dateTime: selectedDate,
      );

      try {
        EasyLoading.show();
        await FirestoreUtils.addTask(taskModel);
        EasyLoading.dismiss();
        SnackBarService.showSuccessMessage('Task added successfully');
        Navigator.pop(context);
      } catch (e) {
        EasyLoading.dismiss();
        SnackBarService.showErrorMessage('Task added failed');
        Navigator.pop(context);
      }
    }
  }
}

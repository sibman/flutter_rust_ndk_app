import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

/// custom imports
import 'package:flutter_rust_ndk_app/utils/persistence.dart';
import 'package:flutter_rust_ndk_app/src/rust/api/model.dart';
import 'package:flutter_rust_ndk_app/utils/colors.dart';
import 'package:flutter_rust_ndk_app/utils/constants.dart';
import 'package:flutter_rust_ndk_app/utils/strings.dart';

// ignore: must_be_immutable
class TaskView extends StatefulWidget {
  const TaskView({
    super.key,
    required this.taskControllerForTitle,
    required this.taskControllerForSubtitle,
    this.task,
  });

  final TextEditingController? taskControllerForTitle;
  final TextEditingController? taskControllerForSubtitle;
  final Task? task;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  String? title;
  String? subtitle;
  String? priority;
  //DateTime? date;

  /// Show Selected Date As String Format
  String showDate(DateTime? date) {
    final formattedDate = date ?? widget.task?.getCreatedAt() ?? DateTime.now();
    return DateFormat.yMMMEd().format(formattedDate);
  }

  // Show Selected Date As DateTime Format
  DateTime showDateAsDateTime(DateTime? date) {
    return date ?? widget.task?.getCreatedAt() ?? DateTime.now();
  }

  /// If any Task Already exist return TRUE otherWise FALSE
  bool isTaskAlreadyExistBool() {
    return widget.taskControllerForTitle?.text != null ||
        widget.taskControllerForSubtitle?.text != null;
  }

  /// Delete Selected Task
  dynamic deleteTask() {
    final taskPersistence =
        Provider.of<TaskPersistenceModel>(context, listen: false);
    return taskPersistence.deleteTask(taskId: widget.task!.getId());
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const TaskViewAppBar(),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildTopText(textTheme),
              _buildMiddleTextFieldsANDTimeAndDateSelection(context, textTheme),
              _buildBottomButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    final isTaskExist = isTaskAlreadyExistBool();
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: isTaskExist
            ? MainAxisAlignment.spaceEvenly
            : MainAxisAlignment.center,
        children: [
          if (isTaskExist) // Show delete button only if task exist
            Container(
              width: 150,
              height: 55,
              decoration: BoxDecoration(
                border: Border.all(
                  color: TodoManagerColorConstants.primaryColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                minWidth: 150,
                height: 55,
                onPressed: () {
                  deleteTask();
                  Navigator.pop(context);
                },
                color: Colors.white,
                child: const Row(
                  children: [
                    Icon(
                      Icons.close,
                      color: TodoManagerColorConstants.primaryColor,
                    ),
                    SizedBox(width: 5),
                    Text(
                      TodoManagerStringConstants.deleteTask,
                      style: TextStyle(
                        color: TodoManagerColorConstants.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            minWidth: 150,
            height: 55,
            onPressed: () {
              isTaskExist ? updateTask() : addTask(); // Call appropriate method
              Navigator.pop(context);
            },
            color: TodoManagerColorConstants.primaryColor,
            child: Text(
              isTaskExist
                  ? TodoManagerStringConstants.updateTaskString
                  : TodoManagerStringConstants.addTaskString,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void updateTask() {
    final taskPersistence =
        Provider.of<TaskPersistenceModel>(context, listen: false);

    if (widget.taskControllerForTitle?.text != null &&
        widget.taskControllerForSubtitle?.text != null) {
      try {
        // Update title and subtitle from TextControllers
        widget.task!.setTitle(title: widget.taskControllerForTitle!.text);
        widget.task!
            .setSubtitle(subtitle: widget.taskControllerForSubtitle!.text);

        // Update task in persistence layer
        taskPersistence.updateTask(
          taskId: widget.task!.getId(),
          title: widget.task!.getTitle(),
          subtitle: widget.task!.getSubtitle(),
          isCompleted: widget.task!.isCompleted(),
          priority: Priority.fromString(value: priority!),
        );
      } catch (error) {
        nothingEnterOnUpdateTaskMode(context); // Handle error (if any)
      }
    } else {
      emptyFieldsWarning(context); // Show warning for empty fields
    }
  }

  void addTask() {
    final taskPersistence =
        Provider.of<TaskPersistenceModel>(context, listen: false);

    if (title != null && subtitle != null) {
      // Save the task in persistence layer
      taskPersistence.createTask(
          taskTitle: title!,
          taskSubtitle: subtitle!,
          taskPriority: Priority.fromString(
              value: priority != null ? priority! : "Normal"));
    } else {
      emptyFieldsWarning(context); // Show warning for empty fields
    }
  }

  Widget _buildMiddleTextFieldsANDTimeAndDateSelection(
    BuildContext context,
    TextTheme textTheme,
  ) {
    List<String> prioritiesItems = ["High", "Normal", "Low"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title Text
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Text(
            TodoManagerStringConstants.titleOfTitleTextField,
            style: textTheme.headlineMedium,
          ),
        ),

        /// Title TextField
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: ListTile(
            title: TextFormField(
              controller: widget.taskControllerForTitle,
              maxLines: 6,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              onFieldSubmitted: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              onChanged: (value) => title = value,
            ),
          ),
        ),

        const SizedBox(height: 10),

        /// Note TextFiled
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: ListTile(
            title: TextFormField(
              controller: widget.taskControllerForSubtitle,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                prefixIcon:
                    const Icon(Icons.bookmark_border, color: Colors.grey),
                border: InputBorder.none,
                counter: Container(),
                hintText: TodoManagerStringConstants.addNote,
              ),
              onFieldSubmitted: (value) => subtitle = value,
              onChanged: (value) => subtitle = value,
            ),
          ),
        ),

        const SizedBox(height: 10),

        Container(
            width: double.infinity,
            height: 50,
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: PriorityDropdown(
              items: prioritiesItems,
              initialValue: widget.task != null
                  ? widget.task!.getPriority().toString()
                  : "Normal",
              onChanged: (value) => priority = value,
            )),

        const SizedBox(height: 10),

        /// Date Picker
        // TextButton(
        //   onPressed: () {
        //     DatePicker.showDatePicker(
        //       context,
        //       showTitleActions: true,
        //       minTime: DateTime.now(),
        //       maxTime: DateTime(2030, 3, 5),
        //       onChanged: (selectedDate) =>
        //           // ignore: avoid_print
        //           print(selectedDate), // Example for intermediate updates
        //       onConfirm: (selectedDate) => setState(() {
        //         date = selectedDate;
        //       }),
        //       currentTime: showDateAsDateTime(date),
        //     );
        //   },
        //   child: Container(
        //     margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        //     width: double.infinity,
        //     height: 55,
        //     decoration: BoxDecoration(
        //       color: Colors.white,
        //       border: Border.all(color: Colors.grey.shade300, width: 1),
        //       borderRadius: BorderRadius.circular(10),
        //     ),
        //     child: Row(
        //       children: [
        //         Padding(
        //           padding: const EdgeInsets.only(left: 10),
        //           child: Text(TodoManagerStringConstants.dateString,
        //               style: textTheme.headlineSmall),
        //         ),
        //         Expanded(child: Container()),
        //         Container(
        //           margin: const EdgeInsets.only(right: 10),
        //           width: 140,
        //           height: 35,
        //           decoration: BoxDecoration(
        //             borderRadius: BorderRadius.circular(10),
        //             color: Colors.grey.shade100,
        //           ),
        //           child: Center(
        //             child: Text(
        //               showDate(date), // Rebuild Text widget with updated date
        //               style: textTheme.titleSmall,
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildTopText(TextTheme textTheme) {
    final isTaskExist = isTaskAlreadyExistBool();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Divider(thickness: 2),
        RichText(
          text: TextSpan(
              text: isTaskExist
                  ? TodoManagerStringConstants.updateCurrentTask
                  : TodoManagerStringConstants.addNewTask,
              style: textTheme.titleLarge,
              children: const [
                TextSpan(
                  text: TodoManagerStringConstants.taskString,
                  style: TextStyle(fontWeight: FontWeight.w400),
                )
              ]),
        ),
        const Divider(thickness: 2),
      ],
    );
  }
}

class PriorityDropdown extends StatefulWidget {
  final List<String> items; // List of dropdown menu items
  final String initialValue; // Initial selected value
  final Function(String) onChanged; // Callback for selection changes

  const PriorityDropdown({
    super.key,
    required this.items,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<PriorityDropdown> createState() => _PriorityDropdownState();
}

class _PriorityDropdownState extends State<PriorityDropdown> {
  late String _selectedValue; // State variable for selected value

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selectedValue,
      isExpanded: true, // Expand dropdown to fill available width
      items: widget.items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedValue = newValue!; // Update state with new value
          widget.onChanged(newValue); // Call callback with new value
        });
      },
    );
  }
}

/// AppBar
class TaskViewAppBar extends StatelessWidget implements PreferredSizeWidget {
  // ignore: use_super_parameters
  const TaskViewAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 40,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

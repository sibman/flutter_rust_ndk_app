import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

///
//import '../../../models/task.dart';
import 'package:flutter_rust_ndk_app/src/rust/api/simple.dart';
import 'package:flutter_rust_ndk_app/src/rust/api/model.dart';
import '../../../utils/colors.dart';
import '../../../view/tasks/task_view.dart';

class TaskWidget extends StatefulWidget {
  // ignore: use_super_parameters
  const TaskWidget({Key? key, required this.task}) : super(key: key);

  final Task task;

  @override
  // ignore: library_private_types_in_public_api
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  TextEditingController taskControllerForTitle = TextEditingController();
  TextEditingController taskControllerForSubtitle = TextEditingController();
  @override
  void initState() {
    super.initState();
    taskControllerForTitle.text = widget.task.getTitle();
    taskControllerForSubtitle.text = widget.task.getSubtitle();
  }

  @override
  void dispose() {
    taskControllerForTitle.dispose();
    taskControllerForSubtitle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (ctx) => TaskView(
              taskControllerForTitle: taskControllerForTitle,
              taskControllerForSubtitle: taskControllerForSubtitle,
              task: widget.task,
            ),
          ),
        );
      },

      /// Main Card
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            color: widget.task.isCompleted()
                ? const Color.fromARGB(154, 119, 144, 229)
                : Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(.1),
                  offset: const Offset(0, 4),
                  blurRadius: 10)
            ]),
        child: ListTile(

            /// Check icon
            leading: GestureDetector(
              onTap: () {
                widget.task
                    .setCompleted(isCompleted: !widget.task.isCompleted());
                updateTask(
                  taskId: widget.task.getId(),
                  title: widget.task.getTitle(),
                  subtitle: widget.task.getSubtitle(),
                  isCompleted: widget.task.isCompleted(),
                  priority: widget.task.getPriority(),
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                decoration: BoxDecoration(
                    color: widget.task.isCompleted()
                        ? MyColors.primaryColor
                        : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey, width: .8)),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              ),
            ),

            /// title of Task
            title: Padding(
              padding: const EdgeInsets.only(bottom: 5, top: 3),
              child: Text(
                taskControllerForTitle.text,
                style: TextStyle(
                    color: widget.task.isCompleted()
                        ? MyColors.primaryColor
                        : Colors.black,
                    fontWeight: FontWeight.w500,
                    decoration: widget.task.isCompleted()
                        ? TextDecoration.lineThrough
                        : null),
              ),
            ),

            /// Description of task
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  taskControllerForSubtitle.text,
                  style: TextStyle(
                    color: widget.task.isCompleted()
                        ? MyColors.primaryColor
                        : const Color.fromARGB(255, 164, 164, 164),
                    fontWeight: FontWeight.w300,
                    decoration: widget.task.isCompleted()
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),

                /// Date & Time of Task
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10,
                      top: 10,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('hh:mm a')
                              .format(widget.task.getCreatedAt()),
                          style: TextStyle(
                              fontSize: 14,
                              color: widget.task.isCompleted()
                                  ? Colors.white
                                  : Colors.grey),
                        ),
                        Text(
                          DateFormat.yMMMEd()
                              .format(widget.task.getCreatedAt()),
                          style: TextStyle(
                              fontSize: 12,
                              color: widget.task.isCompleted()
                                  ? Colors.white
                                  : Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

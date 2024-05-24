import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

///
import 'package:flutter_rust_ndk_app/utils/persistence.dart';
import 'package:flutter_rust_ndk_app/src/rust/api/model.dart';
import 'package:flutter_rust_ndk_app/utils/colors.dart';
import 'package:flutter_rust_ndk_app/utils/constants.dart';
import 'package:flutter_rust_ndk_app/view/home/widgets/task_widget.dart';
import 'package:flutter_rust_ndk_app/view/tasks/task_view.dart';
import 'package:flutter_rust_ndk_app/utils/strings.dart';

class HomeView extends StatefulWidget {
  // ignore: use_super_parameters
  const HomeView({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GlobalKey<SliderDrawerState> dKey = GlobalKey<SliderDrawerState>();

  /// Checking The Value Of the Circle Indicator
  // dynamic calculateValueOfProgressIndicator(List<Task> task) {
  //   if (task.isNotEmpty) {
  //     return task.length;
  //   } else {
  //     return 1;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final taskPersistence =
        Provider.of<TaskPersistenceModel>(context, listen: false);
    final textTheme = Theme.of(context).textTheme;

    return ValueListenableBuilder<Task>(
      valueListenable: taskPersistence.notifier(),
      builder: (context, tasks, _) {
        // No need to call readAllTasks or sort within the builder
        var tasks = taskPersistence.readAllTasks(
          createdAt: DateTime.now(),
          isCompletedOnly: false,
          isIgnoreCreatedAt: true,
        );
        return Scaffold(
          backgroundColor: Colors.white,
          floatingActionButton: const FloatingActionButton(),
          body: SliderDrawer(
            isDraggable: false,
            key: dKey,
            animationDuration: 1000,
            appBar: HomeViewAppBar(
              drawerKey: dKey,
            ),
            slider: const HomeViewSlider(),
            child: _buildBody(tasks, textTheme),
          ),
        );
      },
    );
  }

  /// Main Body
  Widget _buildBody(
    List<Task> tasks,
    TextTheme textTheme,
  ) {
    final taskPersistence =
        Provider.of<TaskPersistenceModel>(context, listen: false);

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          // Top Section
          _buildTopSection(tasks, textTheme, taskPersistence),

          // Divider
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Divider(
              thickness: 2,
              indent: 100,
            ),
          ),

          // Bottom List or Done Message
          _buildTaskListOrDoneMessage(tasks, taskPersistence),
        ],
      ),
    );
  }

// Separated Widget for Top Section
  Widget _buildTopSection(List<Task> tasks, TextTheme textTheme,
      TaskPersistenceModel taskPersistence) {
    final valueOfProgressForDivision = tasks.isNotEmpty ? tasks.length : 1;
    final valueOfProgress = tasks.length;

    return Flexible(
        flex: 1,
        child: Container(
          margin: const EdgeInsets.fromLTRB(55, 0, 0, 0),
          width: double.infinity,
          height: 77,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// CircularProgressIndicator
              SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(
                  valueColor: const AlwaysStoppedAnimation(
                      TodoManagerColorConstants.primaryColor),
                  backgroundColor: Colors.grey,
                  value: taskPersistence.countDoneTask() /
                      valueOfProgressForDivision,
                ),
              ),
              const SizedBox(width: 25),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(TodoManagerStringConstants.mainTitle,
                      style: textTheme.displayLarge),
                  const SizedBox(height: 3),
                  Text(
                      "${taskPersistence.countDoneTask()} of $valueOfProgress ${TodoManagerStringConstants.taskStrings}",
                      style: textTheme.titleMedium),
                ],
              )),
            ],
          ),
        ));
  }

// Separated Widget for Task List or Done Message
  Widget _buildTaskListOrDoneMessage(
      List<Task> tasks, TaskPersistenceModel taskPersistence) {
    return Flexible(
      flex: 5,
      child: tasks.isNotEmpty
          ? ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: tasks.length,
              itemBuilder: (BuildContext context, int index) {
                final task = tasks[index];
                return Dismissible(
                  direction: DismissDirection.horizontal,
                  background: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delete_outline,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(TodoManagerStringConstants.deletedTask,
                          style: TextStyle(
                            color: Colors.grey,
                          ))
                    ],
                  ),
                  onDismissed: (direction) {
                    taskPersistence.deleteTask(taskId: task.getId());
                  },
                  key: Key(task.getId().toString()),
                  child: TaskWidget(
                    task: tasks[index],
                  ),
                );
              },
            )

          /// if All Tasks Done Show this Widgets
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Lottie
                FadeIn(
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Lottie.asset(
                      lottieURL,
                      animate:
                          tasks.isEmpty, // Animate only when tasks are empty
                    ),
                  ),
                ),

                /// Bottom Texts
                FadeInUp(
                  from: 30,
                  child: const Text(TodoManagerStringConstants.doneAllTask),
                ),
              ],
            ),
    );
  }
}

/// My Drawer Slider
class HomeViewSlider extends StatelessWidget {
  // ignore: use_super_parameters
  const HomeViewSlider({
    Key? key,
  }) : super(key: key);

  /// Icons
  final List<IconData> icons = const [
    CupertinoIcons.home,
    CupertinoIcons.person_fill,
    CupertinoIcons.settings,
    CupertinoIcons.info_circle_fill,
  ];

  /// Texts
  final List<String> texts = const [
    "Home",
    "Profile",
    "Settings",
    "Details",
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 90),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: TodoManagerColorConstants.primaryGradientColor,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/img/main.png'),
          ),
          const SizedBox(height: 8),
          Text("Andrey Y's TECH", style: textTheme.displayMedium),
          Text("consulting services", style: textTheme.displaySmall),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            width: double.infinity,
            height: 300,
            child: ListView.separated(
                itemCount: icons.length,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 8.0),
                itemBuilder: (ctx, i) {
                  return TextButton(
                      onPressed: () {
                        // Handle button press (consider navigation or functionality)
                        if (kDebugMode) {
                          print("$i Selected");
                        }
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      child: Container(
                          margin: const EdgeInsets.all(5),
                          child: Row(children: [
                            Icon(
                              icons[i],
                              color: Colors.white,
                              size: 30,
                            ),
                            const SizedBox(width: 10),
                            Text(texts[i],
                                style: const TextStyle(color: Colors.white)),
                          ])));
                }),
          )
        ],
      ),
    );
  }
}

/// My App Bar
class HomeViewAppBar extends StatefulWidget implements PreferredSizeWidget {
  // ignore: use_super_parameters
  const HomeViewAppBar({
    Key? key,
    required this.drawerKey,
  }) : super(key: key);
  final GlobalKey<SliderDrawerState> drawerKey;

  @override
  State<HomeViewAppBar> createState() => _HomeViewAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _HomeViewAppBarState extends State<HomeViewAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool isDrawerOpen = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// toggle for drawer and icon animation
  void toggle() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
      if (isDrawerOpen) {
        controller.forward();
        widget.drawerKey.currentState!.openSlider();
      } else {
        controller.reverse();
        widget.drawerKey.currentState!.closeSlider();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskPersistence =
        Provider.of<TaskPersistenceModel>(context, listen: false);

    return SizedBox(
      height: 132,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Animated Menu/Close Icon
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.menu_close,
                    progress: controller,
                    size: 40.0,
                  ),
                  onPressed: toggle),
            ),
            // Delete All Icon with confirmation handling
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  final hasTasks = taskPersistence
                      .readAllTasks(
                          createdAt: DateTime.now(),
                          isCompletedOnly: false,
                          isIgnoreCreatedAt: false)
                      .isNotEmpty;
                  if (hasTasks) {
                    deleteAllTask(context);
                  } else {
                    warningNoTask(context);
                  }
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                icon: const Icon(
                  CupertinoIcons.trash,
                  size: 40.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Floating Action Button
class FloatingActionButton extends StatelessWidget {
  // ignore: use_super_parameters
  const FloatingActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => const TaskView(
                taskControllerForSubtitle: null,
                taskControllerForTitle: null,
                task: null,
              ),
            ),
          );
          FocusManager.instance.primaryFocus?.unfocus();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: TodoManagerColorConstants.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }
}

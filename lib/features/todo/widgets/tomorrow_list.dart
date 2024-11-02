import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/features/todo/controller/todo/todo_provider.dart';
import 'package:todo_app/features/todo/widgets/todo_tiles.dart';

import '../../../common/utils/constants.dart';
import '../../../common/widgets/xpansion_tile.dart';
import '../controller/xpansion_provider.dart';
import '../pages/update_task.dart';
import '../pages/view_task.dart';

class TomorrowList extends ConsumerWidget {
  const TomorrowList({super.key});

  String formatTime(String? timeString) {
    if (timeString == null) return "No Time"; // Handle null case

    // Parse the time string (assume format is "hh:mm")
    final timeParts = timeString.split(':');
    if (timeParts.length != 2) return "Invalid Time"; // Handle invalid format

    final hours = int.parse(timeParts[0]);
    final minutes = int.parse(timeParts[1]);

    // Get tomorrow's date
    final tomorrow = DateTime.now().add(const Duration(days: 1));

    // Create a DateTime object for tomorrow's date with the parsed time
    final dateTime =
        DateTime(tomorrow.year, tomorrow.month, tomorrow.day, hours, minutes);

    // Format the DateTime to desired string format
    return DateFormat.jm().format(dateTime);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoStateProvider);
    var color = ref.read(todoStateProvider.notifier).getRandomColor();
    String tomorrow = ref.read(todoStateProvider.notifier).getTomorrow();
    var tomorrowTask = todos.where(
      (element) => element.date!.contains(tomorrow),
    );

    return XpansionTile(
      text: "Tomorrow's Task",
      text2: "Tomorrow's Task are shown here",
      onExpansionChange: (bool expanded) {
        ref.read(xpansionStateProvider.notifier).setStart(expanded);
      },
      trailing: Padding(
        padding: EdgeInsets.only(right: 12.w),
        child: ref.watch(xpansionStateProvider)
            ? const Icon(
                AntDesign.upcircle,
                color: AppConst.kLight,
              )
            : const Icon(
                AntDesign.circledown,
                color: AppConst.kBlueLight,
              ),
      ),
      children: [
        for (final todo in tomorrowTask)
          GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewTask(id: todo.id ?? 0),
                ),
              );
            },
            child: TodoTiles(
              title: todo.title,
              description: todo.desc,
              color: color,
              start: formatTime(todo.startTime),
              end: formatTime(todo.endTime),
              switcher: const SizedBox.shrink(),
              delete: () {
                ref.read(todoStateProvider.notifier).deleteTodo(todo.id ?? 0);
              },
              editWidget: GestureDetector(
                onTap: () {
                  titleTask = todo.title.toString();
                  descTask = todo.desc.toString();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateTask(
                        id: todo.id ?? 0,
                      ),
                    ),
                  );
                },
                child: const Icon(MaterialCommunityIcons.circle_edit_outline),
              ),
            ),
          ),
      ],
    );
  }
}

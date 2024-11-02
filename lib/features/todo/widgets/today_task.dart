import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/features/todo/pages/update_task.dart';
import 'package:todo_app/features/todo/widgets/todo_tiles.dart';

import '../../../common/models/task_model.dart';
import '../../../common/utils/constants.dart';
import '../controller/todo/todo_provider.dart';
import '../pages/view_task.dart';

class TodayTask extends ConsumerWidget {
  const TodayTask({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Task> listData = ref.watch(todoStateProvider);
    String today = ref.read(todoStateProvider.notifier).getToday();
    var todayList = listData
        .where((element) =>
            element.isCompleted == 0 && element.date!.contains(today))
        .toList();

    return ListView.builder(
      itemCount: todayList.length,
      itemBuilder: (context, index) {
        final data = todayList[index];
        String formattedStartTime = data.startTime != null
            ? DateFormat('hh:mm a')
            .format(DateTime.parse('1970-01-01 ${data.startTime?.trim()}'))
            : 'Unknown Start Time';
        String formattedEndTime = data.endTime != null
            ? DateFormat('hh:mm a')
            .format(DateTime.parse('1970-01-01 ${data.endTime?.trim()}'))
            : 'Unknown End Time';
        bool isCompleted = ref.read(todoStateProvider.notifier).getStatus(data);
        dynamic color = ref.read(todoStateProvider.notifier).getRandomColor();
        return GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewTask(id: data.id ?? 0),
                ),
              );
            },
          child: TodoTiles(
            delete: () {
              ref.read(todoStateProvider.notifier).deleteTodo(data.id ?? 0);
            },
            editWidget: GestureDetector(
              onTap: () {
                titleTask = data.title.toString();
                descTask = data.desc.toString();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateTask(
                      id: data.id ?? 0,
                    ),
                  ),
                );
              },
              child: const Icon(MaterialCommunityIcons.circle_edit_outline),
            ),
            title: data.title,
            description: data.desc,
            color: color,
            start: formattedStartTime,
            end: formattedEndTime,
            switcher: Switch(
              value: isCompleted,
              onChanged: (value) {
                ref.read(todoStateProvider.notifier).markAsCompleted(
                      data.id ?? 0,
                      data.title.toString(),
                      data.desc.toString(),
                      1,
                      data.date.toString(),
                      data.startTime.toString(),
                      data.endTime.toString(),
                    );
              },
            ),
          ),
        );
      },
    );
  }
}

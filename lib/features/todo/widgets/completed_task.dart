import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/common/utils/constants.dart';
import 'package:todo_app/features/todo/widgets/todo_tiles.dart';

import '../../../common/models/task_model.dart';
import '../controller/todo/todo_provider.dart';
import '../pages/view_task.dart';

class CompletedTask extends ConsumerWidget {
  const CompletedTask({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Task> listData = ref.watch(todoStateProvider);
    List lastMonth = ref.read(todoStateProvider.notifier).last30Days();
    var completedList = listData
        .where((element) =>
            element.isCompleted == 1 ||
            lastMonth.contains(element.date!.substring(0, 10)))
        .toList();

    return ListView.builder(
      itemCount: completedList.length,
      itemBuilder: (context, index) {
        final data = completedList[index];
        String formattedStartTime = data.startTime != null
            ? DateFormat('hh:mm a')
            .format(DateTime.parse('1970-01-01 ${data.startTime?.trim()}'))
            : 'Unknown Start Time';
        String formattedEndTime = data.endTime != null
            ? DateFormat('hh:mm a')
            .format(DateTime.parse('1970-01-01 ${data.endTime?.trim()}'))
            : 'Unknown End Time';

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
            editWidget: const SizedBox.shrink(),
            title: data.title,
            description: data.desc,
            color: color,
            start: formattedStartTime,
            end: formattedEndTime,
            switcher: const Icon(
              AntDesign.checkcircle,
              color: AppConst.kGreen,
            ),
          ),
        );
      },
    );
  }
}

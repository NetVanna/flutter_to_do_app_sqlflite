import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/common/models/task_model.dart';
import 'package:todo_app/common/utils/constants.dart';
import 'package:todo_app/common/widgets/app_style.dart';
import 'package:todo_app/common/widgets/custom_outline_button.dart';
import 'package:todo_app/common/widgets/custom_text_field.dart';
import 'package:todo_app/common/widgets/height_spacer.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:todo_app/features/todo/controller/dates/dates_provider.dart';
import 'package:todo_app/features/todo/controller/todo/todo_provider.dart';

class AddTask extends ConsumerStatefulWidget {
  const AddTask({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddTaskState();
}

class _AddTaskState extends ConsumerState<AddTask> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var scheduleDate = ref.watch(datesStateProvider);
    var start = ref.watch(startTimeStateProvider);
    var end = ref.watch(finishTimeStateProvider);
    String formattedDate = scheduleDate.isNotEmpty
        ? DateFormat('dd-MMM-yyyy').format(DateTime.parse(scheduleDate))
        : 'Set Date';

    String formattedStartTime = start.trim().isNotEmpty
        ? DateFormat('hh:mm a').format(DateTime.parse(start.trim()))
        : 'Start Time';

    String formattedEndTime = end.trim().isNotEmpty
        ? DateFormat('hh:mm a').format(DateTime.parse(end.trim()))
        : 'End Time';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: ListView(
          children: [
            const HeightSpacer(height: 20),
            CustomTextField(
              hintText: "Add title",
              controller: titleController,
              hintStyle: appStyle(
                size: 16,
                color: AppConst.kGreyLight,
                fw: FontWeight.w600,
              ),
            ),
            const HeightSpacer(height: 20),
            CustomTextField(
              hintText: "Add Description",
              controller: descController,
              hintStyle: appStyle(
                size: 16,
                color: AppConst.kGreyLight,
                fw: FontWeight.w600,
              ),
            ),
            const HeightSpacer(height: 20),
            CustomOutlineButton(
              text: formattedDate,
              onPressed: () {
                picker.DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    minTime: DateTime(2024, 6, 1),
                    maxTime: DateTime(2030, 6, 1),
                    theme: const picker.DatePickerTheme(
                      doneStyle: TextStyle(
                        color: AppConst.kGreen,
                        fontSize: 16,
                      ),
                    ), onConfirm: (date) {
                  ref
                      .read(datesStateProvider.notifier)
                      .setDate(date.toString());
                }, currentTime: DateTime.now(), locale: picker.LocaleType.en);
              },
              width: AppConst.kWidth,
              height: 52.h,
              color: AppConst.kLight,
              color2: AppConst.kBlueLight,
            ),
            const HeightSpacer(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomOutlineButton(
                  text: formattedStartTime,
                  onPressed: () {
                    picker.DatePicker.showTime12hPicker(
                      context,
                      showTitleActions: true,
                      onConfirm: (date) {
                        ref
                            .read(startTimeStateProvider.notifier)
                            .setStart(date.toString());
                      },
                      currentTime: DateTime.now(),
                    );
                  },
                  width: AppConst.kWidth * 0.4,
                  height: 52.h,
                  color: AppConst.kLight,
                  color2: AppConst.kBlueLight,
                ),
                CustomOutlineButton(
                  text: formattedEndTime,
                  onPressed: () {
                    picker.DatePicker.showTime12hPicker(
                      context,
                      showTitleActions: true,
                      onConfirm: (date) {
                        ref
                            .read(finishTimeStateProvider.notifier)
                            .setStart(date.toString());
                      },
                      currentTime: DateTime.now(),
                    );
                  },
                  width: AppConst.kWidth * 0.4,
                  height: 52.h,
                  color: AppConst.kLight,
                  color2: AppConst.kBlueLight,
                ),
              ],
            ),
            const HeightSpacer(height: 20),
            CustomOutlineButton(
              text: "Submit",
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    descController.text.isNotEmpty &&
                    scheduleDate.isNotEmpty &&
                    start.isNotEmpty &&
                    end.isNotEmpty) {
                  Task task = Task(
                    title: titleController.text,
                    desc: descController.text,
                    isCompleted: 0,
                    date: scheduleDate,
                    startTime: start.substring(10, 16),
                    endTime: end.substring(10, 16),
                    remind: 0,
                    repeat: "yes",
                  );
                  ref.read(todoStateProvider.notifier).addItem(task);
                  ref.read(datesStateProvider.notifier).setDate("");
                  ref.read(startTimeStateProvider.notifier).setStart("");
                  ref.read(finishTimeStateProvider.notifier).setStart("");
                  Navigator.pop(context);
                } else {
                  print("Failed to add task");
                }
              },
              width: AppConst.kWidth,
              height: 52.h,
              color: AppConst.kLight,
              color2: AppConst.kGreen,
            ),
          ],
        ),
      ),
    );
  }
}

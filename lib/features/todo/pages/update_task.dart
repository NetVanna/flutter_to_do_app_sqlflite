import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/common/utils/constants.dart';
import 'package:todo_app/common/widgets/app_style.dart';
import 'package:todo_app/common/widgets/custom_outline_button.dart';
import 'package:todo_app/common/widgets/custom_text_field.dart';
import 'package:todo_app/common/widgets/height_spacer.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:todo_app/features/todo/controller/dates/dates_provider.dart';
import 'package:todo_app/features/todo/controller/todo/todo_provider.dart';

import '../../../common/models/task_model.dart';

class UpdateTask extends ConsumerStatefulWidget {
  const UpdateTask({super.key, required this.id});

  final int id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UpdateTaskState();
}

class _UpdateTaskState extends ConsumerState<UpdateTask> {
  final TextEditingController titleController =
      TextEditingController(text: titleTask);
  final TextEditingController descController =
      TextEditingController(text: descTask);

  @override
  void initState() {
    super.initState();

    // Delay the modification to after the build is done
    Future.delayed(Duration.zero, () {
      Task? task = ref.read(todoStateProvider).firstWhere(
            (task) => task.id == widget.id,
            orElse: () => Task(
              id: widget.id,
              title: 'Not Found',
              desc: 'No Data',
              date: 'Not Date',
              startTime: "No Start Time",
              endTime: "No End Time",
            ),
          );

      // Update the controllers with task details
      titleController.text = task.title!;
      descController.text = task.desc!;

      // Set the date and time if they exist
      if (task.date!.isNotEmpty) {
        ref.read(datesStateProvider.notifier).setDate(task.date!);
      }
      if (task.startTime!.isNotEmpty) {
        ref.read(startTimeStateProvider.notifier).setStart(task.startTime!);
      }
      if (task.endTime!.isNotEmpty) {
        ref.read(finishTimeStateProvider.notifier).setStart(task.endTime!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var scheduleDate = ref.watch(datesStateProvider);
    var start = ref.watch(startTimeStateProvider);
    var end = ref.watch(finishTimeStateProvider);
    String formattedDate = scheduleDate.isNotEmpty
        ? DateFormat('dd-MMM-yyyy').format(DateTime.parse(scheduleDate))
        : 'Set Date';
    String formattedStartTime = 'Start Time';
    String formattedEndTime = 'End Time';

    try {
      final parsedStart = DateFormat('HH:mm').parse(start.trim(), true);
      formattedStartTime = DateFormat('hh:mm a').format(parsedStart);

      final parsedEnd = DateFormat('HH:mm').parse(end.trim(), true);
      formattedEndTime = DateFormat('hh:mm a').format(parsedEnd);
    } catch (e) {
      print('Invalid time format: $e');
    }

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
                        final formattedTime = DateFormat('HH:mm').format(date); // Convert to 24-hour format for storage
                        ref.read(startTimeStateProvider.notifier).setStart(formattedTime);

                        // Update the local variable to display the formatted time
                        setState(() {
                          formattedStartTime = DateFormat('hh:mm a').format(date); // Display in 12-hour format
                        });
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
                        final formattedTime = DateFormat('HH:mm').format(date); // Convert to 24-hour format for storage
                        ref.read(finishTimeStateProvider.notifier).setStart(formattedTime);

                        // Update the local variable to display the formatted time
                        setState(() {
                          formattedEndTime = DateFormat('hh:mm a').format(date); // Display in 12-hour format
                        });
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
                  ref.read(todoStateProvider.notifier).updateItem(
                        widget.id,
                        titleController.text,
                        descController.text,
                        0,
                        scheduleDate,
                        start,
                        // Directly use the raw start time
                        end, // Directly use the raw end time
                      );
                  ref.read(datesStateProvider.notifier).setDate("");
                  ref.read(startTimeStateProvider.notifier).setStart("");
                  ref.read(finishTimeStateProvider.notifier).setStart("");
                  Navigator.pop(context);
                } else {
                  print("Failed to update task");
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

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }
}

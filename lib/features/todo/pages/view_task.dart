import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/common/utils/constants.dart';
import 'package:todo_app/common/widgets/app_style.dart';
import 'package:todo_app/common/widgets/height_spacer.dart';
import 'package:todo_app/common/widgets/reusable_text.dart';
import 'package:todo_app/common/widgets/width_spacer.dart';

import '../../../common/models/task_model.dart';
import '../controller/todo/todo_provider.dart';

class ViewTask extends ConsumerWidget {
  const ViewTask({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the task by ID
    Task? task = ref.watch(todoStateProvider).firstWhere(
          (task) => task.id == id,
          orElse: () => Task(id: id, title: 'Not Found', desc: 'No Data'),
        );
    String formattedDate = task.date != null
        ? DateFormat('dd-MMM-yyyy').format(DateTime.parse(task.date!))
        : 'Unknown Date';
    String formattedStartTime = task.startTime != null
        ? DateFormat('hh:mm a')
            .format(DateTime.parse('1970-01-01 ${task.startTime?.trim()}'))
        : 'Unknown Start Time';
    String formattedEndTime = task.endTime != null
        ? DateFormat('hh:mm a')
            .format(DateTime.parse('1970-01-01 ${task.endTime?.trim()}'))
        : 'Unknown End Time';
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Container(
                width: AppConst.kWidth,
                height: AppConst.kHeight * 0.7,
                decoration: BoxDecoration(
                  color: AppConst.kBkLight,
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppConst.kRadius),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReusableText(
                        text: "Reminder",
                        style: appStyle(
                          size: 35,
                          color: AppConst.kLight,
                          fw: FontWeight.bold,
                        ),
                      ),
                      const HeightSpacer(height: 5),
                      Container(
                        width: AppConst.kWidth,
                        padding: const EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                          color: AppConst.kYellow,
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.h),
                          ),
                        ),
                        child: Column(
                          children: [
                            ReusableText(
                              text: "Date: $formattedDate",
                              style: appStyle(
                                size: 15,
                                color: AppConst.kBkDark,
                                fw: FontWeight.bold,
                              ),
                            ),
                            const HeightSpacer(height: 10),
                            ReusableText(
                              text:
                                  "From: $formattedStartTime To: $formattedEndTime",
                              style: appStyle(
                                size: 15,
                                color: AppConst.kBkDark,
                                fw: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const HeightSpacer(height: 15),
                      ReusableText(
                        maxLines: 4,
                        softWrap: true,
                        text: "${task.title}",
                        style: appStyle(
                          size: 20,
                          color: AppConst.kLight,
                          fw: FontWeight.bold,
                        ),
                      ),
                      const HeightSpacer(height: 10),
                      const Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: AppConst.kLight,
                              endIndent: 10,
                            ),
                          ),
                          Text(
                            "Description",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: AppConst.kLight,
                              indent: 10,
                            ),
                          ),
                        ],
                      ),
                      const HeightSpacer(height: 10),
                      Text(
                        "${task.desc}",
                        maxLines: 8,
                        textAlign: TextAlign.justify,
                        style: appStyle(
                          size: 16,
                          color: AppConst.kLight,
                          fw: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: 12.w,
              top: -10.h,
              child: Image.asset(
                "assets/images/bell.png",
                width: 70.w,
                height: 70.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

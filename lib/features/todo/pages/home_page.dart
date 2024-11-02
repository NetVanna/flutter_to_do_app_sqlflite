import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/common/utils/constants.dart';
import 'package:todo_app/common/widgets/custom_text_field.dart';
import 'package:todo_app/common/widgets/height_spacer.dart';
import 'package:todo_app/common/widgets/reusable_text.dart';
import 'package:todo_app/common/widgets/width_spacer.dart';
import 'package:todo_app/common/widgets/xpansion_tile.dart';
import 'package:todo_app/features/todo/controller/todo/todo_provider.dart';
import 'package:todo_app/features/todo/controller/xpansion_provider.dart';
import 'package:todo_app/features/todo/pages/add_task.dart';
import 'package:todo_app/features/todo/widgets/completed_task.dart';
import 'package:todo_app/features/todo/widgets/todo_tiles.dart';

import '../../../common/widgets/app_style.dart';
import '../widgets/day_after_tomorrow_task.dart';
import '../widgets/today_task.dart';
import '../widgets/tomorrow_list.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin {
  final TextEditingController search = TextEditingController();
  late final TabController tabController =
      TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) {
    ref.watch(todoStateProvider.notifier).refresh();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(85),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(
                      text: "Dashboard",
                      style: appStyle(
                        size: 18,
                        color: AppConst.kLight,
                        fw: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddTask(),
                          ),
                        );
                      },
                      child: Container(
                        width: 25.w,
                        height: 25.h,
                        decoration: BoxDecoration(
                          color: AppConst.kLight,
                          borderRadius:
                              BorderRadius.circular(AppConst.kRadius - 3),
                        ),
                        child: const Icon(
                          Ionicons.add,
                          color: AppConst.kBkDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const HeightSpacer(height: 20),
              CustomTextField(
                hintText: "Search ....",
                controller: search,
                prefixIcon: Container(
                  padding: EdgeInsets.all(14.h),
                  child: GestureDetector(
                    onTap: () {},
                    child: const Icon(
                      AntDesign.search1,
                      color: AppConst.kGreyLight,
                    ),
                  ),
                ),
                suffixIcon: const Icon(
                  FontAwesome.sliders,
                  color: AppConst.kGreyLight,
                ),
              ),
              const HeightSpacer(height: 15),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: ListView(
          children: [
            const HeightSpacer(height: 25),
            Row(
              children: [
                const Icon(
                  FontAwesome.tasks,
                  size: 20,
                  color: AppConst.kLight,
                ),
                const WidthSpacer(width: 10),
                ReusableText(
                  text: "Today's Task",
                  style: appStyle(
                    size: 16,
                    color: AppConst.kLight,
                    fw: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const HeightSpacer(height: 25),
            Container(
              decoration: BoxDecoration(
                color: AppConst.kLight,
                borderRadius: BorderRadius.circular(AppConst.kRadius),
              ),
              child: TabBar(
                controller: tabController,
                indicatorSize: TabBarIndicatorSize.label,
                indicator: BoxDecoration(
                  color: AppConst.kGreyLight,
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppConst.kRadius),
                  ),
                ),
                labelPadding: EdgeInsets.zero,
                isScrollable: false,
                labelColor: AppConst.kBlueLight,
                unselectedLabelColor: AppConst.kLight,
                labelStyle: appStyle(
                  size: 24,
                  color: AppConst.kBlueLight,
                  fw: FontWeight.bold,
                ),
                tabs: [
                  Tab(
                    child: SizedBox(
                      width: AppConst.kWidth * 0.5,
                      child: Center(
                        child: ReusableText(
                          text: "Pending",
                          style: appStyle(
                            size: 16,
                            color: AppConst.kBkDark,
                            fw: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      padding: EdgeInsets.only(left: 30.w),
                      width: AppConst.kWidth * 0.5,
                      child: Center(
                        child: ReusableText(
                          text: "Completed",
                          style: appStyle(
                            size: 16,
                            color: AppConst.kBkDark,
                            fw: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const HeightSpacer(height: 20),
            SizedBox(
              height: AppConst.kHeight * 0.3,
              width: AppConst.kWidth,
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(AppConst.kRadius),
                ),
                child: TabBarView(
                  controller: tabController,
                  children: [
                    Container(
                      height: AppConst.kHeight * 0.3,
                      color: AppConst.kBkLight,
                      child: const TodayTask(),
                    ),
                    Container(
                      height: AppConst.kHeight * 0.3,
                      color: AppConst.kBkLight,
                      child: const CompletedTask(),
                    ),
                  ],
                ),
              ),
            ),
            const HeightSpacer(height: 15),
            const TomorrowList(),
            const HeightSpacer(height: 15),
            const DayAfterTomorrowTask(),
          ],
        ),
      ),
    );
  }
}

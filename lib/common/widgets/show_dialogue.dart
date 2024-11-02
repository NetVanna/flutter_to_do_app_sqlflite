import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/common/utils/constants.dart';
import 'package:todo_app/common/widgets/app_style.dart';
import 'package:todo_app/common/widgets/reusable_text.dart';

showAlertDialog({
  required BuildContext context,
  required String message,
  String? btnText,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: ReusableText(
          text: message,
          style: appStyle(
            size: 18,
            color: AppConst.kLight,
            fw: FontWeight.w600,
          ),
        ),
        contentPadding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0.h),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              btnText ?? "Ok",
              style: appStyle(
                size: 18,
                color: AppConst.kGreyLight,
                fw: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
    },
  );
}

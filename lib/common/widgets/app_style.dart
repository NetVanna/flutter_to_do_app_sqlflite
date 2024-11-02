import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle appStyle(
    {required double size, required Color color, required FontWeight fw}) {
  return GoogleFonts.poppins(
    fontSize: size.sp,
    fontWeight: fw,
    color: color,
  );
}

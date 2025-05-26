import 'package:flutter/material.dart';
import 'package:sixam_mart/util/app_constants.dart';

ThemeData dark({Color color = const Color(0xFFc70043)}) => ThemeData(
      fontFamily: AppConstants.fontFamily,
      primaryColor: color,
      secondaryHeaderColor: const Color(0xFF009f67),
      disabledColor: const Color(0xffa2a7ad),
      brightness: Brightness.dark,
      hintColor: const Color(0xFFbebebe),
      cardColor: const Color(0xFF30313C),
      shadowColor: Colors.white.withValues(alpha: 0.03),
      textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white70)),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: color)),
      colorScheme: ColorScheme.dark(primary: color, secondary: color)
          .copyWith(surface: const Color(0xFF191A26))
          .copyWith(error: const Color(0xFFc70043)),
      popupMenuTheme: const PopupMenuThemeData(
          color: Color(0xFF29292D), surfaceTintColor: Color(0xFF29292D)),
      dialogTheme: const DialogThemeData(surfaceTintColor: Colors.white10),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(500))),
      bottomAppBarTheme: const BottomAppBarTheme(
        surfaceTintColor: Colors.black,
        height: 60,
        padding: EdgeInsets.symmetric(vertical: 5),
      ),
      dividerTheme:
          const DividerThemeData(thickness: 0.5, color: Color(0xFFA0A4A8)),
      tabBarTheme: const TabBarThemeData(dividerColor: Colors.transparent),
    );

// // // import 'package:flutter/material.dart';
// // // import 'package:sixam_mart/util/app_constants.dart';

// // // ThemeData dark({Color color = const Color(0xFF54b46b)}) => ThemeData(
// // //   fontFamily: AppConstants.fontFamily,
// // //   primaryColor: color,
// // //   secondaryHeaderColor: const Color(0xFF009f67),
// // //   disabledColor: const Color(0xffa2a7ad),
// // //   brightness: Brightness.dark,
// // //   hintColor: const Color(0xFFbebebe),
// // //   cardColor: const Color(0xFF30313C),
// // //   shadowColor: Colors.white.withValues(alpha: 0.03),
// // //   textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white70)),
// // //   textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: color)),
// // //   colorScheme: ColorScheme.dark(primary: color, secondary: color)
// // //       .copyWith(surface: const Color(0xFF191A26))
// // //       .copyWith(error: const Color(0xFFdd3135)),
// // //   popupMenuTheme: const PopupMenuThemeData(
// // //     color: Color(0xFF29292D),
// // //     surfaceTintColor: Color(0xFF29292D),
// // //   ),
// // //   dialogTheme: const DialogThemeData(surfaceTintColor: Colors.white10), // Fixed
// // //   floatingActionButtonTheme: FloatingActionButtonThemeData(
// // //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(500)),
// // //   ),
// // //   bottomAppBarTheme: const BottomAppBarTheme(
// // //     surfaceTintColor: Colors.black,
// // //     height: 60,
// // //     padding: EdgeInsets.symmetric(vertical: 5),
// // //   ),
// // //   dividerTheme: const DividerThemeData(thickness: 0.5, color: Color(0xFFA0A4A8)),
// // //   tabBarTheme: const TabBarThemeData(dividerColor: Colors.transparent), // Fixed
// // // );

// import 'package:flutter/material.dart';
// import 'package:sixam_mart/util/app_constants.dart';

// ThemeData dark({Color color = const Color(0xFFc70043)}) => ThemeData(
//       fontFamily: AppConstants.fontFamily,
//       primaryColor: color,
//       secondaryHeaderColor: const Color(0xFFc70043),
//       disabledColor: const Color(0xffa2a7ad),
//       brightness: Brightness.dark,
//       hintColor: const Color(0xFFbebebe),
//       cardColor: const Color(0xFFc70043),
//       shadowColor: Colors.white.withValues(alpha: 0.03),
//       textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white70)),
//       textButtonTheme: TextButtonThemeData(
//           style: TextButton.styleFrom(foregroundColor: color)),
//       colorScheme: ColorScheme.dark(primary: color, secondary: color)
//           .copyWith(surface: const Color(0xFF191A26))
//           .copyWith(error: const Color(0xFFdd3135)),
//       popupMenuTheme: const PopupMenuThemeData(
//           color: Color(0xFF29292D), surfaceTintColor: Color(0xFF29292D)),
//       dialogTheme: const DialogThemeData(surfaceTintColor: Colors.white10),
//       floatingActionButtonTheme: FloatingActionButtonThemeData(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(500))),
//       bottomAppBarTheme: const BottomAppBarTheme(
//         surfaceTintColor: Colors.black,
//         height: 60,
//         padding: EdgeInsets.symmetric(vertical: 5),
//       ),
//       dividerTheme:
//           const DividerThemeData(thickness: 0.5, color: Color(0xFFA0A4A8)),
//       tabBarTheme: const TabBarThemeData(
//           dividerColor:
//               Colors.transparent), // Corrected from TabBArTheme to tabBarTheme
//     );

// // import 'package:flutter/material.dart';
// // import 'package:sixam_mart/util/app_constants.dart';

// // // Change all theme colors to Yellow and error to Red
// // ThemeData dark({Color color = const Color(0xFFFFD600)}) => ThemeData(
// //       fontFamily: AppConstants.fontFamily,
// //       primaryColor: color, // Yellow
// //       secondaryHeaderColor: const Color(0xFFFFD600), // Yellow
// //       disabledColor: const Color.fromARGB(255, 173, 171, 162),
// //       brightness: Brightness.dark,
// //       hintColor: const Color(0xFFbebebe),
// //       cardColor: const Color(0xFFFFD600), // Yellow
// //       shadowColor: Colors.white.withOpacity(0.03),
// //       textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white70)),
// //       textButtonTheme: TextButtonThemeData(
// //         style: TextButton.styleFrom(foregroundColor: color), // Yellow
// //       ),
// //       colorScheme: ColorScheme.dark(
// //         primary: color, // Yellow
// //         secondary: color, // Yellow
// //         surface: const Color(0xFF191A26),
// //         error: const Color(0xFFFF3D00), // Vivid Red
// //       ),
// //       popupMenuTheme: const PopupMenuThemeData(
// //           color: Color(0xFF29292D), surfaceTintColor: Color(0xFF29292D)),
// //       dialogTheme: const DialogThemeData(surfaceTintColor: Colors.white10),
// //       floatingActionButtonTheme: FloatingActionButtonThemeData(
// //           shape:
// //               RoundedRectangleBorder(borderRadius: BorderRadius.circular(500))),
// //       bottomAppBarTheme: const BottomAppBarTheme(
// //         surfaceTintColor: Colors.black,
// //         height: 60,
// //         padding: EdgeInsets.symmetric(vertical: 5),
// //       ),
// //       dividerTheme:
// //           const DividerThemeData(thickness: 0.5, color: Color(0xFFA0A4A8)),
// //       tabBarTheme: const TabBarThemeData(dividerColor: Colors.transparent),
// //     );

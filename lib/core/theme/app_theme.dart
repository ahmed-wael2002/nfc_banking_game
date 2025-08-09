import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextTheme {
  static final appTextTheme = TextTheme(
    titleLarge: AppTextStyles.extraLargeTextStyle50
        .copyWith(color: AppColors.textSecondaryColor),
    titleMedium: AppTextStyles.titleMediumTextStyle40
        .copyWith(color: AppColors.textSecondaryColor),
    titleSmall: AppTextStyles.titleSmallTextStyle30
        .copyWith(color: AppColors.textSecondaryColor),
    bodyLarge: AppTextStyles.bodyLargeTextStyle25
        .copyWith(color: AppColors.textSecondaryColor),
    bodyMedium: AppTextStyles.bodyMediumTextStyle20
        .copyWith(color: AppColors.textSecondaryColor),
    bodySmall: AppTextStyles.bodySmallTextStyle16
        .copyWith(color: AppColors.textSecondaryColor),
    labelMedium: AppTextStyles.extraLargeTextStyle50
        .copyWith(color: AppColors.textSecondaryColor),
  );
}

class AppTextSizes {
  static const bodyVerySmallFontSize12 = 12.0;
  static const bodySmallFontSize14 = 14.0;
  static const bodySmallFontSize16 = 16.0;
  static const bodyMediumFontSize18 = 18.0;
  static const bodyMediumFontSize20 = 20.0;
  static const bodyMediumFontSize25 = 25.0;
  static const bodyLargeFontSize30 = 30.0;
  static const veryLargeFontSize40 = 40.0;
  static const extraLargeFontSize50 = 50.0;
}

class AppTextStyles {
  static const String fontFamily = 'Cairo';
  static const textColor = AppColors.textPrimaryColor;

  static const titleSmallTextStyle30 = TextStyle(
    fontFamily: fontFamily,
    fontSize: AppTextSizes.bodySmallFontSize16,
    fontWeight: FontWeight.w700,
    color: textColor,
    height: 20 / 16,
  );

  static const titleMediumTextStyle40 = TextStyle(
    fontFamily: fontFamily,
    fontSize: AppTextSizes.bodyLargeFontSize30,
    fontWeight: FontWeight.w700,
    color: textColor,
    height: 20 / 30,
  );

  static const bodySmallTextStyle12 = TextStyle(
    fontFamily: fontFamily,
    fontSize: AppTextSizes.bodyVerySmallFontSize12,
    fontWeight: FontWeight.w500,
    color: textColor,
    height: 20 / 12,
  );

  static const bodySmallTextStyle14 = TextStyle(
    fontFamily: fontFamily,
    fontSize: AppTextSizes.bodySmallFontSize14,
    fontWeight: FontWeight.w500,
    color: textColor,
    height: 20 / 14,
  );
  static const bodyVerySmallTextStyle14 = TextStyle(
    fontFamily: fontFamily,
    fontSize: AppTextSizes.bodySmallFontSize14,
    fontWeight: FontWeight.w500,
    color: textColor,
    height: 20 / 12,
  );

  static const bodySmallTextStyle16 = TextStyle(
    fontFamily: fontFamily,
    fontSize: AppTextSizes.bodySmallFontSize16,
    fontWeight: FontWeight.w500,
    color: textColor,
    height: 20 / 16,
  );

  static const bodyMediumTextStyle18 = TextStyle(
    fontFamily: fontFamily,
    fontSize: AppTextSizes.bodyMediumFontSize18,
    fontWeight: FontWeight.w500,
    color: textColor,
    height: 20 / 18,
  );

  static const bodyMediumTextStyle20 = TextStyle(
    fontFamily: fontFamily,
    fontSize: AppTextSizes.bodyMediumFontSize20,
    fontWeight: FontWeight.normal,
    color: textColor,
    height: 20 / 20,
  );
  static const bodyMediumTextStyle25 = TextStyle(
    fontFamily: fontFamily,
    fontSize: AppTextSizes.bodyMediumFontSize25,
    fontWeight: FontWeight.normal,
    color: textColor,
    height: 20 / 25,
  );

  static const TextStyle bodyLargeTextStyle25 = TextStyle(
    fontSize: AppTextSizes.bodyMediumFontSize25,
    fontWeight: FontWeight.w400,
    fontFamily: fontFamily,
    color: textColor,
    height: 20 / 25,
  );

  static const bodyLargeTextStyle30 = TextStyle(
      fontFamily: fontFamily,
      fontSize: AppTextSizes.bodyLargeFontSize30,
      fontWeight: FontWeight.w500,
      color: textColor,
      height: 20 / 30);

  static const veryLargeTextStyle40 = TextStyle(
      fontFamily: fontFamily,
      fontSize: AppTextSizes.veryLargeFontSize40,
      fontWeight: FontWeight.w500,
      color: textColor,
      height: 20 / 40);

  static const extraLargeTextStyle50 = TextStyle(
      fontFamily: fontFamily,
      fontSize: AppTextSizes.extraLargeFontSize50,
      fontWeight: FontWeight.w500,
      color: textColor,
      height: 20 / 50);

  static const appBarTextStyle60 = TextStyle(
      fontSize: 60,
      fontWeight: FontWeight.w700,
      fontFamily: fontFamily,
      color: textColor,
      height: 20 / 60);
}

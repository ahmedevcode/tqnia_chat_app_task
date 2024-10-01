import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tqnia_chat_app_task/core/theming/colors.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(DarkTheme());

  void toggleTheme() {
    if (state is LightTheme) {
      emit(DarkTheme());
    } else {
      emit(LightTheme());
    }
  }
}

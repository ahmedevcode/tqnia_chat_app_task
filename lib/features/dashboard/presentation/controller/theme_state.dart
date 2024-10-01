part of 'theme_cubit.dart';

@immutable
abstract class ThemeState {
  final ThemeData themeData;

  const ThemeState(this.themeData);
}

class LightTheme extends ThemeState {
  LightTheme()
      : super(ThemeData(
          brightness: Brightness.light,
          primaryColor: Kcolor.mainbackgroundcolorlight,
          primaryColorLight: Colors.black45,
          secondaryHeaderColor: Kcolor.conversitioncolorlight,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.black),
          ),
        ));
}

class DarkTheme extends ThemeState {
  DarkTheme()
      : super(ThemeData(
          brightness: Brightness.dark,
          primaryColor: Kcolor.conversitioncolor,
          primaryColorLight: Colors.white54,
          secondaryHeaderColor: Kcolor.mainbackgroundcolor,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
          ),
        ));
}

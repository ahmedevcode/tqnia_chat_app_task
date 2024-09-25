import 'package:bloc/bloc.dart';

class OnboardingCubit extends Cubit<int> {
  OnboardingCubit() : super(0);

  void nextScreen() {
    if (state < 2) {
      emit(state + 1);
    }
  }

  void setPage(int page) {
    emit(page);
  }
}

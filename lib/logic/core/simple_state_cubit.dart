import 'package:bloc/bloc.dart';

class SimpleStateCubit<State> extends Cubit<State> {
  SimpleStateCubit(State initial) : super(initial);

  void setState(State state) => emit(state);
}

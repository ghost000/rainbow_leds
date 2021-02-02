import 'package:bloc/bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    // ignore: avoid_print
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    // ignore: avoid_print
    print(transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    // ignore: avoid_print
    print(error);
    super.onError(cubit, error, stackTrace);
  }
}

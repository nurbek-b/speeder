/* External dependencies */
import 'dart:async';
import 'package:bloc/bloc.dart';

/* Local dependencies */
import 'tab_bar_event.dart';
import 'tab_bar_state.dart';

class TabBarBloc extends Bloc<TabBarEvent, TabBarState> {
  TabBarBloc() : super(TabBarState(currentPage: TabBarEventType.showSpeedometer));

  @override
  Stream<TabBarState> mapEventToState(
      TabBarEvent event,
      ) async* {
    switch (event.type) {
      case TabBarEventType.showSpeedometer:
        yield state.cloneWith(currentPage: TabBarEventType.showSpeedometer);

        break;
      case TabBarEventType.showStatistics:
        yield state.cloneWith(currentPage: TabBarEventType.showStatistics);

        break;
      case TabBarEventType.showProfile:
        yield state.cloneWith(currentPage: TabBarEventType.showProfile);

        break;
    }
  }
}

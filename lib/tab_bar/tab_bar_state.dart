/* Local dependencies */
import 'tab_bar_event.dart';

class TabBarState {
  TabBarEventType currentPage;

  TabBarState({
    /* App Tab Bar state */
    this.currentPage = TabBarEventType.showSpeedometer,
  });

  TabBarState cloneWith({
    /* App Tab Bar state */
    currentPage,

  }) {
    return new TabBarState(
      /* App Tab Bar state */
      currentPage: currentPage ?? this.currentPage,
    );
  }
}
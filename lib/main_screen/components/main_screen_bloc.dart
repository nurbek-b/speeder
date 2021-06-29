/* External dependencies */
import 'dart:async';
import 'package:bloc/bloc.dart';

/* Local dependencies */
import 'main_screen_event.dart';
import 'main_screen_state.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  MainScreenBloc() : super(MainScreenState(velocity: 0, velocityUnit: 'KMH'));

  @override
  Stream<MainScreenState> mapEventToState(
    MainScreenEvent event,
  ) async* {
    switch (event.type) {
      case MainScreenEventType.showSpeedometer:
        yield state.cloneWith(currentMode: MainScreenEventType.showSpeedometer);

        break;
      case MainScreenEventType.showHud:
        yield state.cloneWith(currentMode: MainScreenEventType.showHud);

        break;
      case MainScreenEventType.showMap:
        yield state.cloneWith(currentMode: MainScreenEventType.showMap);

        break;
      case MainScreenEventType.getInitialCoordinates:
        final GetInitialCoordinatesEvent ev =
            event as GetInitialCoordinatesEvent;
        double latitude = ev.latitude;
        double longitude = ev.longitude;

        yield state.cloneWith(latitude: latitude, longitude: longitude);

        break;

      case MainScreenEventType.changeVelocityUnit:
        final ChangeVelocityUnitEvent ev = event as ChangeVelocityUnitEvent;
        String velocityUnit = ev.velocityUnit;
        print('Velocity unit $velocityUnit');

        yield state.cloneWith(velocityUnit: velocityUnit);
        break;

      case MainScreenEventType.changeScale:
        final ChangeScaleEvent ev = event as ChangeScaleEvent;
        int maxVelocity = ev.maxVelocity;
        String scale = ev.scale;
        print('Max velocity $maxVelocity');

        yield state.cloneWith(maxVelocity: maxVelocity, scale: scale);
        break;

      case MainScreenEventType.setAlert:
        final SetAlertOverVelocityEvent ev = event as SetAlertOverVelocityEvent;
        bool alert = ev.alert;
        print('Alert $alert');

        yield state.cloneWith(overVelocityAlert: alert);
        break;

      case MainScreenEventType.setLimit:
        final SetVelocityLimitEvent ev = event as SetVelocityLimitEvent;
        int limit = ev.velocityLimit;
        print('Limit $limit');

        yield state.cloneWith(velocityLimit: limit);
        break;
    }
  }
}

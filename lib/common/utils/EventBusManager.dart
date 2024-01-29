import 'package:event_bus/event_bus.dart';

class EventBusManager {
  EventBusManager._privateConstructor();
  static final EventBusManager _instance =
      EventBusManager._privateConstructor();
  factory EventBusManager() {
    return _instance;
  }

  final EventBus _eventBus = EventBus();

  EventBus get eventBus => _eventBus;
}

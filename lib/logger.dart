import 'package:logging/logging.dart';

final Logger logger = Logger('MyApp');

void setupLogging() {
  Logger.root.level = Level.ALL; // Set the log level
  Logger.root.onRecord.listen((LogRecord rec) {
    // You can customize the output here
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}
import 'package:flutter_web_plugins/url_strategy.dart';
import 'lib/main.dart' as entrypoint;

void main() {
  // Use hash-less URLs for better web experience
  usePathUrlStrategy();

  // Call the main app entry point
  entrypoint.main();
}

const String GOOGLE_MAPS_API_KEY = "AIzaSyCq8atDB9bWZFMc-FZY7fag9HAu7wg0_wI";

String get userApi {
  bool isProd = const bool.fromEnvironment('dart.vm.product');
  if (isProd) {
    return 'https://tbd';
    // replace with your production API endpoint
  }

  return "http://10.0.2.2:8081";
  // replace with your own development API endpoint
}

String get routeApi {
  bool isProd = const bool.fromEnvironment('dart.vm.product');
  if (isProd) {
    return 'https://tbd';
    // replace with your production API endpoint
  }

  return "http://10.0.2.2:8080";
  // replace with your own development API endpoint
}
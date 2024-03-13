String get userApi {
  bool isProd = const bool.fromEnvironment('dart.vm.product');
  if (isProd) {
    return 'https://tbd';
    // replace with your production API endpoint
  }

  return "http://localhost:8081";
  // replace with your own development API endpoint
}

String get routeApi {
  bool isProd = const bool.fromEnvironment('dart.vm.product');
  if (isProd) {
    return 'https://tbd';
    // replace with your production API endpoint
  }

  return "http://localhost:8080";
  // replace with your own development API endpoint
}
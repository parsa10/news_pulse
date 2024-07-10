import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

final httpClientProvider = Provider<Client>((ref) {
  final client = Client();

  ref.onDispose(client.close);

  return client;
});

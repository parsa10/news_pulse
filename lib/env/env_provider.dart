import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_pulse/env/base/env_base.dart';

final envProvider = Provider<EnvBase>((ref) {
  return EnvBase();
});

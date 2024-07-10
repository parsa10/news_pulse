import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:isar/isar.dart';
import 'package:news_pulse/env/base/env_base.dart';
import 'package:news_pulse/env/env_provider.dart';
import 'package:news_pulse/src/core/database/database.dart';
import 'package:news_pulse/src/core/utils/providers.dart';

mixin RefDep {
  @protected
  Ref get ref;
}

mixin HttpClientDep on RefDep {
  @protected
  Client get http => ref.read(httpClientProvider);
}

mixin EnvDep on RefDep {
  @protected
  EnvBase get env => ref.read(envProvider);
}

mixin DatabaseDep on RefDep {
  @protected
  Isar get database => ref.read(databaseProvider);
}

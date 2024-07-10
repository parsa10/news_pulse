import 'package:envied/envied.dart';
import 'package:news_pulse/env/base/env_base.dart';

part 'env_staging.g.dart';

@Envied(path: 'env/dev.env')
class EnvStaging extends EnvBase {}

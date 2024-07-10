import 'package:envied/envied.dart';
import 'package:news_pulse/env/base/env_base.dart';

part 'env_prod.g.dart';

@Envied(path: 'env/dev.env')
class EnvProd extends EnvBase {}

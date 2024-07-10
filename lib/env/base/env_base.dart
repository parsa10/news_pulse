import 'package:envied/envied.dart';

part 'env_base.g.dart';

@Envied(path: 'env/base.env')
class EnvBase {
  @EnviedField(
    varName: 'API_KEY',
  )
  final String apiKey = _EnvBase.apiKey;
}

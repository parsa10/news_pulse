import 'package:news_pulse/bootstrap.dart';
import 'package:news_pulse/env/env_provider.dart';
import 'package:news_pulse/env/prod/env_prod.dart';
import 'package:news_pulse/src/app.dart';

void main() {
  bootstrap(
    builder: App.new,
    flavorOverrides: [
      envProvider.overrideWithValue(EnvProd()),
    ],
  );
}

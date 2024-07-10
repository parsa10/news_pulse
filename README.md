# News Pulse

![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

---

## Getting Started 🚀

This project contains 3 flavors:

- development
- staging
- production

To run the desired flavor either use the launch configuration in VSCode/Android Studio or use the
following commands:

```sh
# Development
$ flutter run --flavor development --target lib/main_development.dart

# Staging
$ flutter run --flavor staging --target lib/main_staging.dart

# Production
$ flutter run --flavor production --target lib/main_production.dart
```

_\*News Pulse works on iOS, Android, Web, and Windows._

---

## Running Tests 🧪

To run all unit and widget tests use the following command:

```sh
$ flutter test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report you can
use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/index.html
```

---

## Architecture 🧪

The "[Flutter App Architecture With RiverPod](https://codewithandrea.com/articles/flutter-app-architecture-riverpod-introduction/)"
described in this documentation is a customized architecture for building
Flutter apps with RiverPod DI/State Manager. It provides developers with a clear
structure for their code and makes it easy to manage the app's state. The
documentation recommends the online course to help with understanding this
architecture, as well as other important topics such as code style and tools. By
implementing this architecture, developers can build high-quality, scalable
Flutter applications.

You can read deeply detailed description about each layer in these links:

* [Flutter App Architecture: The Repository Pattern](https://codewithandrea.com/articles/flutter-repository-pattern/)
* [Flutter App Architecture: The Domain Model](https://codewithandrea.com/articles/flutter-app-architecture-domain-model/)
* [Flutter App Architecture: The Application Layer](https://codewithandrea.com/articles/flutter-app-architecture-application-layer/)
* [Flutter App Architecture: The Presentation Layer](https://codewithandrea.com/articles/flutter-presentation-layer/)

## Summary

* Controllers: Uses when we need some ui-related logics after user input and
  before calling services or repos. (Widget States)
* Repositories: Uses as a data setter/getter from multiple possible source link
  remote source or local ones. (Kind of Providers in other architectures)
* Services: Uses when we have some logics between Controllers and Repos. (
  Application State and Shared Logics Between Multiple Pages)

Please keep in mind that:

* _Repos probably use a single source but services call multiple repos and in
  this way use multiple sources._
* _Repos should not depend on other repos._

## Ref as a Parameter or Dependencies as Parameters

For dependencies of our services and repos we can just add a `ref` as parameter and only pass
that to constructor of our service. For every dependency that we need we just
use `ref.read()` whenever necessary.`news_service.dart` is example of the this
approach.

## Dependency Injection with Mixins

In this project, we use Dart mixins to facilitate dependency injection, which lets us write 
`newsRepo.getArticles()` instead of `ref.read(newsRepoProvider).getArticles()` which is more 
readable and easier to write and we can also easily see the dependencies of a service in a glance
like thw following:

```dart
class NewsService with RefDep, ConnectivityRepoDep, NewsRepoDep, LocalNewsRepoDep
```

## Fpdart
Fpdart is a Dart package that brings functional programming paradigms to Dart and Flutter development.
It provides a suite of tools for handling side effects, managing data transformations, and 
improving code robustness through immutability and type safety.

### Key Concepts of Fpdart
Either: A type that represents two possible values, Left (commonly used for errors) or 
Right (commonly used for successful results).

Option: A type that represents an optional value, Some (a value is present) or None (no value is present).

TaskEither: A type that combines asynchronous computations (Task) with Either, useful
for handling asynchronous operations that can fail.


## Environment Variables

The [envied][envied_link] package is used for handling environment variables. To
support different variables in
different flavors the following structure is used:

```
├── EnvBase
│   ├── EnvDev
│   ├── EnvStg
│   └── EnvProd
```

You need an `env` directory at the root of your project with 4 files in it:
`base.env`, `dev.env`, `stg.env` and `prod.env`.

### Adding New Variables

If the variable is the same across all flavors simply add following
to `base.env`:

```
NEW_KEY=NEW_VARIABLE
```

and add the following to `EnvBase` class:

```dart

@EnviedField(
  varName: 'NEW_KEY',
  obfuscate: true, // if it's a sensitive value
)
final newKey = _EnvBase.newKey;
```

and finally run `flutter packages pub run build_runner build` in terminal to
generate the necessary code.

## Working with Translations 🌐

This project relies on [flutter_localizations][flutter_localizations_link] and follows
the [official internationalization guide for Flutter][internationalization_link].

### Adding Strings

1. To add a new localizable string, open the `app_en.arb` file at `lib/l10n/arb/app_en.arb`.

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

2. Then add a new key/value and description

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    },
    "helloWorld": "Hello World",
    "@helloWorld": {
        "description": "Hello World Text"
    }
}
```

3. Use the new string

```dart
import 'package:news_pulse/l10n/l10n.dart';

@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.helloWorld);
}
```

### Adding Supported Locales

Update the `CFBundleLocalizations` array in the `Info.plist` at `ios/Runner/Info.plist` to include
the new locale.

```xml
    ...

<key>CFBundleLocalizations</key>    <array>
<string>en</string>
<string>es</string>
</array>

    ...
```

### Adding Translations

1. For each supported locale, add a new ARB file in `lib/l10n/arb`.

```
├── l10n
│   ├── arb
│   │   ├── app_en.arb
│   │   └── app_es.arb
```

2. Add the translated strings to each `.arb` file:

`app_en.arb`

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

`app_es.arb`

```arb
{
    "@@locale": "es",
    "counterAppBarTitle": "Contador",
    "@counterAppBarTitle": {
        "description": "Texto mostrado en la AppBar de la página del contador"
    }
}
```

### Generating Translations

To use the latest translations changes, you will need to generate them:

1. Generate localizations for the current project:

```sh
flutter gen-l10n --arb-dir="lib/l10n/arb"
```

Alternatively, run `flutter run` and code generation will take place automatically.

[coverage_badge]: coverage_badge.svg

[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html

[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg

[license_link]: https://opensource.org/licenses/MIT

[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg

[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis

[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli

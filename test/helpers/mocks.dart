import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_pulse/src/features/news/data/connectivity_repo.dart';
import 'package:news_pulse/src/features/news/data/local_news_repo.dart';
import 'package:news_pulse/src/features/news/data/news_repo.dart';

class MockNewsRepo extends Mock implements NewsRepo {}

class MockConnectivityRepo extends Mock implements ConnectivityRepo {}

class MockLocalNewsRepo extends Mock implements LocalNewsRepo {}

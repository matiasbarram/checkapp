import 'package:flutter_dotenv/flutter_dotenv.dart';

final String baseURL = dotenv.env['BASE_URL'] ?? 'http://localhost:3000';
final bool envDebug = dotenv.env['DEBUG'] == '1' ? true : false;
final Map testData = {
  'email': "smj@sml.com",
  "pass": "tomandoleche123",
};

const String baseVersion = '/api/v1';
final String apiURL = baseURL + baseVersion;
const String cookieName = 'mysession';

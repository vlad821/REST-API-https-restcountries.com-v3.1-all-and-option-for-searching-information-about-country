
import 'package:flutter_application_1/country_api.dart';
import 'package:flutter_application_1/country_model.dart';

class CountryService {
  final _api = CountryApi();
  Future<List<Country>?> getAllCountries() async {
    return _api.getAllCountries();
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_application_1/country_model.dart';
import 'package:flutter_application_1/country_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Country>? countries;
  List<Country>? filteredCountries;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    loadCountries();
  }

  Future<void> loadCountries() async {
    final countryService = CountryService();
    countries = await countryService.getAllCountries();
    setState(() {
      filteredCountries = countries;
      isLoaded = true;
    });
  }

  void _runFilter(String enteredKeyword) {
    setState(() {
      filteredCountries = countries!
          .where((Country country) =>
              country.name != null &&
              country.name!.common != null &&
              country.name!.common!
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoaded && filteredCountries != null
          ? SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Expanded(
                          child: Text('Name', textAlign: TextAlign.center)),
                      Expanded(
                          child: Text('Capital', textAlign: TextAlign.center)),
                      Expanded(
                          child:
                              Text('Continent', textAlign: TextAlign.center)),
                      Expanded(
                          child: Text('Flag', textAlign: TextAlign.center)),
                    ],
                  ),
                  TextField(
                    onChanged: (value) => _runFilter(value),
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: filteredCountries!
                              .map(
                                (Country country) => Column(
                                  children: [
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                                country.name!.common ?? 'No name')),
                                        Expanded(
                                          child: Text(
                                              country.capital!.isNotEmpty ? country.capital!.first : 'No capital'),
                                        ),
                                        Expanded(
                                          child: Text(
                                              country.continents!.isNotEmpty ? country.continents!.first : 'No continents'),
                                        ),
                                        Expanded(
                                            child: country.flags!.png != null
                                                ? Image.network(
                                                    country.flags!.png!)
                                                : const Icon(
                                                    Icons.flag_rounded)),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    const Divider(),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

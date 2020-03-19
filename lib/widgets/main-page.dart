import 'package:corona/services/store.dart';
import 'package:corona/utils/utils.dart';
import 'package:corona/widgets/stat-widget.dart';
import 'package:corona/widgets/ui/grayed-out.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class HomePage extends StatelessWidget {
  final store = CoronaDataStore();

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppTheme.white,
            elevation: 0,
            title: Text(
              'Corona Virus Stats',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: FlagIcon(
                  countryCode: store.countryCode,
                ),
              ),
              CountryCodePicker(
                showFlag: true,
                builder: (country) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                ),
                onChanged: updateCountry,
                enabled: true,
                showCountryOnly: false,
              ),
            ],
          ),
          backgroundColor: AppTheme.whitish,
          body: Container(
            color: AppTheme.whitish,
            child: Column(
              children: <Widget>[
                Flexible(child: store.isFetching ? NoStats() : GeneralStats(store: store)),
                Expanded(
                  child: Container(color: Colors.greenAccent),
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await store.fetchLatest();
            },
            child: Icon(Icons.public),
          ),
        );
      },
    );
  }

  void updateCountry(CountryCode country) {
    store.changeCountry(country);
  }
}

class GeneralStats extends StatelessWidget {
  const GeneralStats({
    Key key,
    @required this.store,
  }) : super(key: key);

  final CoronaDataStore store;

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: store.isFetching ? CircularProgressIndicator() : SizedBox(),
          ),
          GrayedOut(
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: StatContainer(
                          iconData: Icons.person,
                          statTitle: 'Confirmed Cases',
                          stat: store.countryStats.confirmed.toString(),
                          statColor: Color.fromRGBO(81, 45, 168, 1.0),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: StatContainer(
                          iconData: Icons.person,
                          statTitle: 'Recovered Cases',
                          stat: store.countryStats.recovered.toString(),
                          statColor: Color.fromRGBO(0, 121, 107, 1.0),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: StatContainer(
                          iconData: Icons.person,
                          statTitle: 'Death Cases',
                          stat: store.countryStats.deaths.toString(),
                          statColor: Color.fromRGBO(194, 24, 91, 1.0),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: StatContainer(
                          iconData: Icons.person,
                          statTitle: 'Fatality Rate',
                          stat: (store.countryStats.confirmed != 0 && store.countryStats.confirmed !=null) ?  ((store.countryStats.deaths/store.countryStats.confirmed).toStringAsPrecision(3)* 100).toString() : 'No Data',
                          statColor: Color.fromRGBO(136, 14, 79, 1.0),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
            grayedOut: store.isFetching,
          ),
        ],
      );
  }
}

class FlagIcon extends StatelessWidget {
  final CountryCode countryCode;

  const FlagIcon({Key key, this.countryCode}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(countryCode.flagUri,
          package: 'country_code_picker', width: 50),
    );
  }
}

class NoStats extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
          GrayedOut(
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: StatContainer(
                          iconData: Icons.person,
                          statTitle: 'Confirmed Cases',
                          stat: '1000',
                          statColor: Color.fromRGBO(81, 45, 168, 1.0),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: StatContainer(
                          iconData: Icons.person,
                          statTitle: 'Recovered Cases',
                          stat: '1000',
                          statColor: Color.fromRGBO(0, 121, 107, 1.0),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: StatContainer(
                          iconData: Icons.person,
                          statTitle: 'Death Cases',
                          stat: '1000',
                          statColor: Color.fromRGBO(194, 24, 91, 1.0),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: StatContainer(
                          iconData: Icons.person,
                          statTitle: 'Fatality Rate',
                          stat: '1000',
                          statColor: Color.fromRGBO(136, 14, 79, 1.0),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
            grayedOut: true,
          ),
        ],
      ),
    );
  }
}
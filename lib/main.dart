import 'package:flutter/material.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:material_color_generator/material_color_generator.dart';
import 'package:moneytracker/screen/budget_screen.dart';
import 'package:moneytracker/screen/home_screen.dart';
import 'package:moneytracker/screen/more_screen.dart';
import 'package:moneytracker/screen/transaction_screen.dart';
import 'package:moneytracker/service/budget_service.dart';
import 'package:moneytracker/service/config_service.dart';
import 'package:moneytracker/util/ThemeUtil.dart';
import 'package:moneytracker/util/application_config.dart';

import 'model/config.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Tracker',
      theme: ThemeData(
        primarySwatch: generateMaterialColor(color: ThemeUtil.getDefaultThemeColor()),
        backgroundColor: generateMaterialColor(color: ThemeUtil.getDefaultThemeColor()),
        iconTheme: IconThemeData(color: ThemeUtil.getDefaultThemeColor()),
        listTileTheme: ListTileThemeData(iconColor: ThemeUtil.getDefaultThemeColor()),
          scaffoldBackgroundColor: generateMaterialColor(color: ThemeUtil.getDefaultThemeScaffoldBackgroundColor()),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(color: ThemeUtil.getDefaultThemeAppBarTextColor(), fontSize: 20.0, fontWeight: FontWeight.w500)
        )
      ),
      localizationsDelegates: const [
        FormBuilderLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: FormBuilderLocalizations.delegate.supportedLocales,
      home: const BaseScreen(),
      navigatorObservers: [routeObserver],
    );
  }
}

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int index = 0;
  bool isConfigLoaded = false;
  final ConfigService _configService = ConfigService();
  final ApplicationConfig _applicationConfig = ApplicationConfig();

  @override
  void initState() {
    _configService.getConfigMap().then((configs) {
      for(Config config in configs) {
        var map = <String, String>{};
        map[config.configKey] = config.configValue;
        _applicationConfig.configMap?.addAll(map);
        setState(() {
          isConfigLoaded = true;
        });
      }
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [const HomeScreen(), const BudgetScreen(), const TransactionScreen(), const MoreScreen()];
    return isConfigLoaded ? Scaffold(
      body: screens[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: ThemeUtil.getDefaultThemeColor(),
          labelTextStyle: MaterialStateProperty.all(
              const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ),
        child: NavigationBar(
          backgroundColor: Colors.white,
          height: 60,
          selectedIndex: index,
          onDestinationSelected: (index) {
            setState(() {
              this.index = index;
            });
          },
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined,), label: "Home",selectedIcon: Icon(Icons.home_outlined, color: Colors.white,),),
            NavigationDestination(icon: Icon(Icons.money), label: "Budget", selectedIcon: Icon(Icons.money, color: Colors.white,),),
            NavigationDestination(
                icon: Icon(Icons.compare_arrows), label: "Transactions", selectedIcon: Icon(Icons.compare_arrows, color: Colors.white,)),
            NavigationDestination(icon: Icon(Icons.more_horiz), label: "More", selectedIcon: Icon(Icons.more_horiz, color: Colors.white,))
          ],
        ),
      ),
    ) : const CircularProgressIndicator();
  }
}

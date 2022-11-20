import 'package:flutter/material.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:material_color_generator/material_color_generator.dart';
import 'package:moneytracker/screen/budget.dart';
import 'package:moneytracker/screen/home.dart';
import 'package:moneytracker/screen/home_screen.dart';
import 'package:moneytracker/screen/more.dart';
import 'package:moneytracker/screen/more_screen.dart';
import 'package:moneytracker/screen/transaction_screen.dart';
import 'package:moneytracker/service/budget_service.dart';
import 'package:moneytracker/util/ThemeUtil.dart';

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
  bool _isBudgetExists = false;
  bool _forYear = false;
  bool _noTransaction = false;

  final BudgetService _budgetService = BudgetService();

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [const HomeScreen(), Budget(_isBudgetExists, _forYear, _noTransaction), const TransactionScreen(), const MoreScreen()];

    return Scaffold(
      body: screens[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.blue.shade100,
          labelTextStyle: MaterialStateProperty.all(
              const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ),
        child: NavigationBar(
          backgroundColor: Colors.white,
          height: 60,
          selectedIndex: index,
          onDestinationSelected: (index) {
            if(index == 1) {
              _budgetService.checkBudgetExists().then((budget) {
                setState(() {
                  budget.isNotEmpty  ? _isBudgetExists = true : _isBudgetExists = false;
                  budget.isNotEmpty && budget.first.forYear == 1 ? _forYear = true : _forYear = false;
                  budget.isEmpty ? _noTransaction = true : _noTransaction = false;
                  this.index = index;
                });
              });
            } else {
              setState(() {
                this.index = index;
              });
            }
          },
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home,), label: "Home"),
            NavigationDestination(icon: Icon(Icons.money), label: "Budget"),
            NavigationDestination(
                icon: Icon(Icons.arrow_back), label: "Transactions"),
            NavigationDestination(icon: Icon(Icons.more_horiz), label: "More")
          ],
        ),
      ),
    );
  }
}

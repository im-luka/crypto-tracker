import 'package:cryptocurrency_api/blocks/crypto/crypto_bloc.dart';
import 'package:cryptocurrency_api/repositories/crypto_repository.dart';
import 'package:cryptocurrency_api/screens/home_screen.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  EquatableConfig.stringify = kDebugMode;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return RepositoryProvider(
      create: (context) => CryptoRepository(),
      child: MaterialApp(
        title: 'Cryptocurrency API',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: const ColorScheme(
            primary: Colors.black,
            primaryVariant: Colors.black,
            secondary: Colors.tealAccent,
            secondaryVariant: Colors.tealAccent,
            surface: Colors.yellow,
            background: Colors.blueGrey,
            error: Colors.red,
            onPrimary: Colors.white,
            onSecondary: Colors.black,
            onSurface: Colors.blue,
            onBackground: Colors.black54,
            onError: Colors.redAccent,
            brightness: Brightness.light,
          ),
        ),
        home: BlocProvider(
          create: (context) => CryptoBloc(
            cryptoRepository: context.read<CryptoRepository>(),
          )..add(AppStarted()),
          child: const HomeScreen(),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sparky_for_reddit/providers/auth.dart';
import 'package:sparky_for_reddit/screens/home_screen.dart';
import 'package:sparky_for_reddit/widgets/reddit_redirect.dart';
import 'package:sparky_for_reddit/widgets/wrapper.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => Auth())],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.deepPurple[200],
            primaryContainer: const Color(0x003700B3),
            secondary: Colors.teal[200],
            background: Colors.black,
            surface: const Color.fromRGBO(34, 34, 34, 1),
            error: const Color(0x00CF6679),
            onPrimary: Colors.black,
            onSecondary: Colors.black,
            onBackground: Colors.white,
            onSurface: Colors.white,
            onError: Colors.black,
            brightness: Brightness.dark,
          ),
          splashColor: Colors.deepPurple[200],
          textTheme: TextTheme(
            button: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            headline1: GoogleFonts.supermercadoOne(
              fontSize: 50,
            ),
            headline2: GoogleFonts.supermercadoOne(
              fontSize: 15,
              color: Colors.grey,
            ),
            headline3: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
            headline4: const TextStyle(
              color: Colors.grey,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            bodyText1: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            subtitle1: const TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
            subtitle2: TextStyle(
              color: Colors.deepPurple[200],
            ),
          ),
          scaffoldBackgroundColor: const Color(0x00121212),
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.light,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            actionsIconTheme: IconThemeData(
              color: Colors.white,
              size: 40,
            ),
            color: Colors.black,
          ),
        ),
        home: const Wrapper(),
        routes: {
          HomeScreen.routeName: (ctx) => const HomeScreen(),
        },
        onGenerateRoute: (settings) {
          Uri uri = Uri.parse(settings.name.toString());
          switch (uri.path) {
            case '/authorize_callback':
              {
                String query = uri.query;
                return MaterialPageRoute(
                  builder: (ctx) => RedditRedirect(query),
                );
              }
          }
          return null;
        },
      ),
    );
  }
}

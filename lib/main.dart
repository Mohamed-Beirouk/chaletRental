import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nudilk/provider/ChaletsProvider.dart';
import 'package:nudilk/screens/AdminScreen/AllRequestChalets_screen.dart';
import 'package:nudilk/screens/AdminScreen/adminPanel_screen.dart';
import 'package:nudilk/screens/AdminScreen/allChalets_screen.dart';
import 'package:nudilk/screens/AdminScreen/chaletsReqest_screen.dart';
import 'package:nudilk/screens/AdminScreen/users_screen.dart';
import 'package:nudilk/screens/UserScreen/Landing_Screen.dart';
import 'package:nudilk/screens/UserScreen/bookingConfirmation_screen.dart';
import 'package:nudilk/screens/UserScreen/bookingNow_screen.dart';
import 'package:nudilk/screens/UserScreen/home_screen.dart';
import 'package:nudilk/screens/UserScreen/search.dart';
import 'package:nudilk/screens/UserScreen/updateProfile_screen.dart';
import 'package:nudilk/screens/auth/forgetPassword_screen.dart';
import 'package:nudilk/screens/auth/login_screen.dart';
import 'package:nudilk/screens/auth/signUp_screen.dart';
import 'package:nudilk/screens/auth/splash_screen.dart';
import 'package:nudilk/screens/owner/OwnerHomeScreen.dart';
import 'package:nudilk/screens/owner/addChaletConfirmation_screen.dart';
import 'package:nudilk/screens/owner/addChalet_screen.dart';
import 'package:nudilk/screens/owner/bookingStatus_screen.dart';
import 'package:nudilk/screens/owner/chaletsListScreen.dart';
import 'package:nudilk/screens/owner/ownerPanel_screen.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'provider/UsersProvider.dart';
import 'screens/GuestScreen/GuestLanding_Screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ChaletsProvider>(
          create: (context) {
            return ChaletsProvider();
          },
        ),
        ChangeNotifierProvider<UsersProvider>(
          create: (context) {
            return UsersProvider();
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        //  initialRoute: OwnerHomeScreen.id,
        home: App(),
        routes: {
          SplashScreen.id: (context) => SplashScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          ForgetPasswordScreen.id: (context) => ForgetPasswordScreen(),
          SignUpScreen.id: (context) => SignUpScreen(),
          HomeScreen.id: (context) => HomeScreen(),
          LandingScreen.id: (context) => LandingScreen(),
          UpDateProfileScreen.id: (context) => UpDateProfileScreen(),
          BookingNowScreen.id: (context) => BookingNowScreen(),
          BookingConfirmationScreen.id: (context) =>
              BookingConfirmationScreen(),
          AdminChaletsScreen.id: (context) => AdminChaletsScreen(),
          UsersScreen.id: (context) => UsersScreen(),
          ChaletsRequestScreen.id: (context) => ChaletsRequestScreen(),
          AdminPanelScreen.id: (context) => ChaletsRequestScreen(),
          AddChaletScreen.id: (context) => AddChaletScreen(),
          AddChaletConfirmationScreen.id: (context) =>
              AddChaletConfirmationScreen(),
          OwnerHomeScreen.id: (context) => OwnerHomeScreen(),
          ChaletsListScreen.id: (context) => ChaletsListScreen(),
          OwnerPanelScreen.id: (context) => OwnerPanelScreen(),
          BookingStatusScreen.id: (context) => BookingStatusScreen(),
          Search.id: (context) => Search(),
          GuestLandingScreen.id: (context) => GuestLandingScreen(),
          AllRequestAdminChaletsScreen.id: (context) =>
              AllRequestAdminChaletsScreen(),
        },
      ),
    ),
  );
}

class App extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(35.0),
                    child: Container(
                      height: 80,
                      width: 80,
                      child: Image.asset('assets/images/email.png'),
                    ),
                  ),
                  const Text(
                    'Error with Firebase',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.red),
                  ),
                ],
              ),
            ),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return SplashScreen();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Scaffold(
          body: Center(
            child: Text(
              'loading',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}

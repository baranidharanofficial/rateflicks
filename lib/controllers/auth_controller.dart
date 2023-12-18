import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pricetracker/data/api_data.dart';
import 'package:pricetracker/data/local_storage.dart';
import 'package:pricetracker/home.dart';
import 'package:pricetracker/pages/login.dart';

class AuthController extends GetxController {
  DataApi dataApi = DataApi();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final auth = FirebaseAuth.instance;

  login(email, password, context) async {
    debugPrint("Login");

    try {
      String token = await localStoreGetToken() ?? "";

      debugPrint("FCM Token :  $token");

      bool isLoggedIn = await dataApi.loginUser(email, password, token);

      if (isLoggedIn) {
        final UserCredential loginData = await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        await localStoreSetEmail(loginData.user!.email ?? "");
        goToHome(context);
      } else {
        await _googleSignIn.signOut();
        showSnackbar(context, "Invalid Credentials");
      }
    } catch (err) {
      debugPrint("Error $err");
      showSnackbar(context, "Something went wrong");
    }
  }

  loginWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? data = await _googleSignIn.signIn();

      String userName = data!.displayName!;
      String profilePicture = data.photoUrl!;

      debugPrint("$userName  -- $profilePicture");

      String token = await localStoreGetToken() ?? "";

      debugPrint("FCM Token :  $token");

      bool isLoggedIn = await dataApi.loginUser(data.email, '123456789', token);

      if (isLoggedIn) {
        final UserCredential loginData = await auth.signInWithEmailAndPassword(
          email: data.email,
          password: '123456789',
        );
        await localStoreSetEmail(loginData.user!.email ?? "");
        goToHome(context);
      } else {
        await _googleSignIn.signOut();
        showSnackbar(context, "User didn't exists");
      }
    } catch (err) {
      debugPrint("Error : $err");
      await _googleSignIn.signOut();
      showSnackbar(context, "Something went wrong");
    }
  }

  signUp(email, password, context) async {
    debugPrint("Sign Up");

    try {
      String token = await localStoreGetToken() ?? "";

      debugPrint("FCM Token :  $token");

      bool isLoggedIn = await dataApi.registerUser(
        email,
        password,
        token,
      );

      if (isLoggedIn) {
        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (userCredential.user!.email == email) {
          final UserCredential loginData =
              await auth.signInWithEmailAndPassword(
            email: email,
            password: '123456789',
          );
          await localStoreSetEmail(loginData.user!.email ?? "");
          goToHome(context);
        }
      } else {
        debugPrint("Something went wrong");
        showSnackbar(context, "Email is already registered");
      }
    } catch (err) {
      debugPrint("Error $err");
    }
  }

  signUpWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? data = await _googleSignIn.signIn();

      String userName = data!.displayName!;
      String profilePicture = data.photoUrl!;

      debugPrint("$userName  -- $profilePicture");

      String token = await localStoreGetToken() ?? "";

      debugPrint("FCM Token :  $token");

      bool isLoggedIn =
          await dataApi.registerUser(data.email, '123456789', token);

      if (isLoggedIn) {
        final UserCredential loginData =
            await auth.createUserWithEmailAndPassword(
          email: data.email,
          password: '123456789',
        );
        await localStoreSetEmail(loginData.user!.email ?? "");
        goToHome(context);
      } else {
        await _googleSignIn.signOut();
        showSnackbar(context, "Email is already registered");
      }
    } catch (err) {
      debugPrint("Error : $err");
      await _googleSignIn.signOut();
      showSnackbar(context, "Something went wrong");
    }
  }

  goToHome(context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }
}

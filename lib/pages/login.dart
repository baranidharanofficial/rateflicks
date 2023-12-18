import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pricetracker/controllers/auth_controller.dart';
import 'package:pricetracker/home.dart';
import 'package:pricetracker/data/local_storage.dart';
import 'package:pricetracker/pages/signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? isSignedIn;
  AuthController authController = Get.put(AuthController());
  bool showLoader = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _emailNode = false;
  bool _passwordNode = false;
  String? scheduledTime;

  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      isSignedIn = await localStoreGetEmail();
      setState(() {});
      checkIsLoggedIn(isSignedIn ?? "");
    });
  }

  checkIsLoggedIn(String isSignedIn) {
    if (isSignedIn.isNotEmpty) {
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    }
  }

  @override
  dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Text("Sign in",
                        style: TextStyle(
                          // fontFamily: controller.font,
                          fontSize: width * 0.07,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        )),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      // border: Border.all(
                      //     width: 0.5,
                      //     color: _emailNode
                      //         ? Theme.of(context).primaryColor
                      //         : const Color(0xEBE5E5E5)),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: TextField(
                      controller: emailController,
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Email",
                        fillColor: Colors.white,
                        focusColor: Theme.of(context).primaryColor,
                        icon: Icon(
                          Icons.email,
                          color: _emailNode
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).primaryColorDark,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _emailNode = true;
                          _passwordNode = false;
                        });
                      },
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      // border: Border.all(
                      //     width: _passwordNode ? 0.5 : 0,
                      //     color: _passwordNode
                      //         ? Theme.of(context).primaryColor
                      //         : const Color(0xEBE5E5E5)),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Password",
                        fillColor: Colors.white,
                        focusColor: Theme.of(context).primaryColor,
                        icon: Icon(
                          Icons.password,
                          color: _passwordNode
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).primaryColorDark,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _emailNode = false;
                          _passwordNode = true;
                        });
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      print(emailController.text);
                      print(passwordController.text);

                      showLoader = true;
                      setState(() {});

                      if (emailController.text.isNotEmpty &&
                          passwordController.text.length > 6) {
                        await authController.login(emailController.text,
                            passwordController.text, context);
                      } else {
                        showSnackbar(context, 'Fill all the fields');
                      }
                      showLoader = false;
                      setState(() {});
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      margin: const EdgeInsets.only(top: 40, bottom: 20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: const Center(
                          child: Text(
                        "Sign in",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      )),
                    ),
                  ),
                  const Text(
                    "OR",
                    style: TextStyle(
                      fontSize: 15,
                      // fontFamily: controller.font,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      showLoader = true;
                      setState(() {});
                      await authController.loginWithGoogle(context);
                      showLoader = false;
                      setState(() {});
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      margin: const EdgeInsets.only(top: 20, bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Image.asset(
                          //   "assets/google.png",
                          //   height: 20,
                          // ),
                          Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: Text(
                              "Sign in with Google",
                              style: TextStyle(
                                // fontFamily: controller.font,
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()));
                    },
                    child: Text(
                      "Don't have an account? Sign up",
                      style: TextStyle(
                        // fontFamily: controller.font,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: showLoader,
          child: Positioned.fill(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: const Color(0xA6212121),
              child: Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).primaryColor,
          fontSize: 15,
        ),
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: Theme.of(context).primaryColorLight,
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pricetracker/controllers/auth_controller.dart';
import 'package:pricetracker/home.dart';
import 'package:pricetracker/pages/login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  AuthController authController = Get.find();
  bool showLoader = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _emailNode = false;
  bool _passwordNode = false;
  String? scheduledTime;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
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
        duration: const Duration(seconds: 2),
        backgroundColor: Theme.of(context).primaryColorLight,
      ),
    );
  }

  goToHome() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
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
                    child: Text("Sign up",
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
                        // hintStyle: TextStyle(fontFamily: controller.font),
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
                        await authController.signUp(emailController.text,
                            passwordController.text, context);
                      } else {
                        showSnackbar(context, "Fill all the fields");
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
                        "Sign up",
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
                      await authController.signUpWithGoogle(context);
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
                              "Sign up with Google",
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
                              builder: (context) => const LoginScreen()));
                    },
                    child: Text(
                      "Already have an account? Login",
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/view/screen/auth/sign_up_screen.dart';
import 'package:weather_app/view/screen/auth/widget/input_field.dart';
import '../../../data/model/response/user_model.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../base/button.dart';
import '../../base/show_snackbar.dart';
import '../dashboard/dashboard_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Get.theme.cardColor,
        body: ListView(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          children: [
            const SizedBox(
              height: 100,
            ),
            const SizedBox(
              height: 40,
            ),
            Center(
              child: Text(
                "Welcome To Sign In!",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: Dimensions.fontSizeExtraLarge),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            InputField(
              backgroundColor: Get.theme.scaffoldBackgroundColor,
              width: Get.width,
              subTitle: "Enter Email",
              prefixIcon: const Icon(
                Icons.email,
                color: Colors.black,
              ),
              title: "Email",
              controller: emailController,
              focusNode: emailFocusNode,
              nextFocus: passwordFocusNode,
            ),
            const SizedBox(
              height: Dimensions.paddingSizeDefault,
            ),
            InputField(
              backgroundColor: Get.theme.scaffoldBackgroundColor,
              width: Get.width,
              subTitle: "Enter Password",
              prefixIcon: const Icon(
                Icons.lock,
                color: Colors.black,
              ),
              title: "Password",
              controller: passwordController,
              focusNode: passwordFocusNode,
            ),
            const SizedBox(
              height: Dimensions.paddingSizeOverLarge,
            ),
            !isLoading
                ? Button(
                    title: "Login",
                    onTap: () {
                      submit();
                    },
                    radius: 12,
                  )
                : const Center(child: CircularProgressIndicator()),
            const SizedBox(
              height: Dimensions.paddingSizeDefault,
            ),
            InkWell(
              onTap: () {
                Get.to(() => const SignUpScreen());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Create a new account?",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                  Text(
                    " Sign Up",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Future<void> signInWithEmailAndPassword(UserModel userModel) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      getData(userModel);
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      setState(() {});
      if (e.code == 'user-not-found') {
        if (kDebugMode) {
          showCustomSnackBar("No user found for that email", isError: true);
        }
      } else if (e.code == 'wrong-password') {
        if (kDebugMode) {
          showCustomSnackBar("Wrong password provided for that user.",
              isError: true);
        }
      }
    }
  }

  FirebaseFirestore db = FirebaseFirestore.instance;

  void getData(UserModel userModel) {
    db.collection("users").get().then(
      (res) {
        isLoading = false;
        setState(() {});
        Get.offAll(() => const DashBoardScreen());
      },
      onError: (e) => debugPrint("Error completing: $e"),
    );
  }

  void submit() {
    if (emailController.text.trim().isNotEmpty) {
      if (passwordController.text.trim().isNotEmpty) {
        UserModel user = UserModel(
          email: emailController.text,
        );
        isLoading = true;
        setState(() {});
        signInWithEmailAndPassword(user);
      } else {
        showCustomSnackBar('Enter Password', isError: true);
        passwordFocusNode.requestFocus();
      }
    } else {
      showCustomSnackBar('Enter Email', isError: true);
      emailFocusNode.requestFocus();
    }
  }
}

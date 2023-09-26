import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/view/screen/auth/sign_in_screen.dart';
import 'package:weather_app/view/screen/auth/widget/input_field.dart';
import '../../../data/model/response/user_model.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../base/button.dart';
import '../../base/show_snackbar.dart';
import '../dashboard/dashboard_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode numberFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Get.theme.cardColor,
        body: ListView(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          children: [
            const SizedBox(
              height: 50,
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Text(
                "Welcome To Sign Up!",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: Dimensions.fontSizeExtraLarge),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InputField(
              backgroundColor: Get.theme.scaffoldBackgroundColor,
              width: Get.width,
              subTitle: "Enter Name",
              prefixIcon: const Icon(
                Icons.person,
                color: Colors.black,
              ),
              title: "Name",
              controller: nameController,
              focusNode: nameFocusNode,
              nextFocus: emailFocusNode,
            ),
            const SizedBox(
              height: Dimensions.paddingSizeDefault,
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
              nextFocus: numberFocusNode,
            ),
            const SizedBox(
              height: Dimensions.paddingSizeDefault,
            ),
            InputField(
              backgroundColor: Get.theme.scaffoldBackgroundColor,
              width: Get.width,
              subTitle: "Enter Number",
              prefixIcon: const Icon(
                Icons.call,
                color: Colors.black,
              ),
              title: "Number",
              controller: numberController,
              focusNode: numberFocusNode,
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
              nextFocus: confirmPasswordFocusNode,
            ),
            const SizedBox(
              height: Dimensions.paddingSizeDefault,
            ),
            InputField(
              backgroundColor: Get.theme.scaffoldBackgroundColor,
              width: Get.width,
              subTitle: "Enter Confirm Password",
              prefixIcon: const Icon(
                Icons.lock,
                color: Colors.black,
              ),
              title: "Confirm Password",
              controller: confirmPasswordController,
              focusNode: confirmPasswordFocusNode,
            ),
            const SizedBox(
              height: Dimensions.paddingSizeOverLarge,
            ),
            !isLoading
                ? Button(
                    title: "Register",
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
                Get.to(() => const SignInScreen());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                  Text(
                    " Sign In",
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

  void submit() {
    if (nameController.text.trim().isNotEmpty) {
      if (numberController.text.trim().isNotEmpty) {
        if (emailController.text.trim().isNotEmpty) {
          if (passwordController.text.trim().isNotEmpty) {
            if (confirmPasswordController.text.trim().isNotEmpty) {
              if (passwordController.text == confirmPasswordController.text) {
                UserModel user = UserModel(
                  name: nameController.text.trim().toString(),
                  number: numberController.text.trim().toString(),
                  email: emailController.text.trim().toString(),
                );

                isLoading = true;
                setState(() {});
                createUserWithEmailAndPassword(user);
              } else {
                showCustomSnackBar('Password Mismatch', isError: true);
                confirmPasswordFocusNode.requestFocus();
              }
            } else {
              showCustomSnackBar('Enter Confirm Password', isError: true);
              confirmPasswordFocusNode.requestFocus();
            }
          } else {
            showCustomSnackBar('Enter Password', isError: true);
            passwordFocusNode.requestFocus();
          }
        } else {
          showCustomSnackBar('Enter Email', isError: true);
          emailFocusNode.requestFocus();
        }
      } else {
        showCustomSnackBar('Enter Number', isError: true);
        numberFocusNode.requestFocus();
      }
    } else {
      showCustomSnackBar('Enter Name', isError: true);
      nameFocusNode.requestFocus();
    }
  }

  Future<void> createUserWithEmailAndPassword(UserModel userModel) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      )
          .then((value) {
        userModel.createdAt = DateTime.now().millisecondsSinceEpoch;
        userModel.uid = value.user!.uid;
        addUser(userModel);
      });
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      setState(() {});
      if (e.code == 'weak-password') {
        if (kDebugMode) {
          showCustomSnackBar("The password provided is too weak.",
              isError: true);
        }
      } else if (e.code == 'email-already-in-use') {
        if (kDebugMode) {
          showCustomSnackBar("The account already exists for that email.",
              isError: true);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(UserModel userModel) async {
    users.doc(userModel.uid).set(userModel.toJson()).then((value) {
      isLoading = false;
      setState(() {});
      Get.offAll(() => const DashBoardScreen());
    }).catchError((error) => null);
  }
}

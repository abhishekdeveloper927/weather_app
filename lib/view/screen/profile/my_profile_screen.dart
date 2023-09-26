import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/view/base/button.dart';
import 'package:weather_app/view/screen/auth/sign_in_screen.dart';
import 'package:weather_app/view/screen/profile/widget/profile_data_field.dart';

import '../../../util/dimensions.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
        .collection('users')
        .where("uid", isEqualTo: currentUser!.uid)
        .snapshots();
    return Scaffold(
      backgroundColor: Get.theme.cardColor,
      body: StreamBuilder(
          stream: usersStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;

                  return Expanded(
                    child: Column(children: [
                      const SizedBox(
                        height: 30,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: Container(
                          padding:  EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeDefault),
                          decoration: BoxDecoration(
                              color: Get.theme.scaffoldBackgroundColor,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(30),
                                topLeft: Radius.circular(30),
                              )),
                          child: ListView(
                            children: [
                              const SizedBox(
                                height: 40,
                              ),
                              const SizedBox(
                                height: Dimensions.paddingSizeDefault,
                              ),
                              ProfileDataField(
                                  title: "Name", subTitle: data['name']),
                              const SizedBox(
                                height: Dimensions.paddingSizeDefault,
                              ),
                              ProfileDataField(
                                  title: "Email", subTitle: data['email']),
                              const SizedBox(
                                height: Dimensions.paddingSizeDefault,
                              ),
                              ProfileDataField(
                                  title: "Number",
                                  subTitle: data['number'] ?? ""),
                              const SizedBox(
                                height: Dimensions.paddingSizeDefault,
                              ),
                              ProfileDataField(
                                title: "Joined ",
                                subTitle: DateFormat('EEE, d MMM').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        data['createdAt'] * 1000)),
                              ),
                              const SizedBox(
                                height: 40,
                              ),

                              Button(title: "Logout", onTap: () async {

                                await FirebaseAuth.instance
                                    .signOut();
                                Get.offAll(
                                        () => const SignInScreen());
                              })
                            ],

                          ),
                        ),
                      ),
                    ]),
                  );
                }).toList());
          }),
    );
  }
}

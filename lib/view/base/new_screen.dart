import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../util/dimensions.dart';

class AnimationScreen extends StatefulWidget {
  const AnimationScreen({super.key});

  @override
  State<AnimationScreen> createState() => _AnimationScreenState();
}

class _AnimationScreenState extends State<AnimationScreen> {
  TextEditingController searchController = TextEditingController();
  FocusNode focusNode = FocusNode();
  double value = 0.0;
  List<String> name = [
    "Abhishek",
    "Sagar",
    "Rishabh",
    "Sourabh",
    "Ayush",
    "Mansi",
    "Priyanshi"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(
            height: Dimensions.paddingSizeOverLarge,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            width: Get.width,
            height: 55,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: TextFormField(
              controller: searchController,
              focusNode: focusNode,
              onChanged: (_) {
                setState(() {});
              },
              style: const TextStyle(fontSize: 14, color: Colors.black),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                    size: 22,
                  ),
                  hintText: "Search",
                  hintStyle: TextStyle(fontSize: 14, color: Colors.black26)),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          name
                  .where((element) => element
                      .toLowerCase()
                      .contains(searchController.text.trim().toLowerCase()))
                  .toList()
                  .isNotEmpty
              ? ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: name
                      .where((element) => element
                          .toLowerCase()
                          .contains(searchController.text.trim().toLowerCase()))
                      .toList()
                      .length,
                  itemBuilder: (context, index) {
                    String names = name
                        .where((element) => element.toLowerCase().contains(
                            searchController.text.trim().toLowerCase()))
                        .toList()[index];
                    return Text(
                      names,
                      style: const TextStyle(color: Colors.black),
                    );
                  })
              : const Center(
                  child: Text(
                    "No Name Found",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 500),
                tween: Tween(begin: 0.0, end: value),
                child: Container(width: 120, height: 120, color: Colors.red),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(value * 165, value * 165),
                    child: child,
                  );
                },
              ),
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 500),
                tween: Tween(begin: 0.0, end: value),
                child: Container(width: 120, height: 120, color: Colors.yellow),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(value * -165, value * 165),
                    child: child,
                  );
                },
              ),
            ],
          ),
          const SizedBox(
            height: Dimensions.paddingSizeDefault,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 500),
                tween: Tween(begin: 0.0, end: value),
                child: Container(width: 120, height: 120, color: Colors.green),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(value * 165, value * -165),
                    child: child,
                  );
                },
              ),
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 500),
                tween: Tween(begin: 0.0, end: value),
                child: Container(width: 120, height: 120, color: Colors.blue),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(value * -165, value * -165),
                    child: child,
                  );
                },
              ),
            ],
          ),
          const SizedBox(
            height: 80,
          ),
          Center(
            child: SizedBox(
              width: Get.width / 2,
              child: Slider.adaptive(
                value: value,
                onChanged: (values) => setState(() => value = values),
              ),
            ),
          )
        ],
      ),
    );
  }
}

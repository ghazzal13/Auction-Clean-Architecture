import 'package:auction_clean_architecture/core/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../features/authentication/login_screen.dart';

class BordingModel {
  final String Image;
  final String Titel;
  final String Body;
  BordingModel(
    this.Image,
    this.Titel,
    this.Body,
  );
}

class OnBorderingScreen extends StatefulWidget {
  const OnBorderingScreen({Key? key}) : super(key: key);

  @override
  State<OnBorderingScreen> createState() => _OnBorderingScreenState();
}

class _OnBorderingScreenState extends State<OnBorderingScreen> {
  var pageborder = PageController();
  var isLast = false;
  List<BordingModel> bording = [
    BordingModel('asset/image/mazadat_1.png', 'Titel1', 'Body1'),
    BordingModel('asset/image/mazadat_1.png', 'Titel2', 'Body2'),
    BordingModel('asset/image/mazadat_1.png', 'Titel3', 'Body3'),
  ];

  Future MM2() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('onBordering', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            child: const Text(
              'skip',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor),
            ),
            onPressed: () {
              MM2()
                  // Chache()
                  //     .saveData(key: 'onBordering', value: true)
                  .then((value) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                    (route) => false);
              });
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                itemBuilder: (context, index) =>
                    buildBoardingiItem(bording[index]),
                onPageChanged: (int index) {
                  if (index == bording.length - 1) {
                    setState(() {
                      isLast = true;
                    });
                  } else {
                    setState(() {
                      isLast = false;
                    });
                  }
                },
                itemCount: bording.length,
                controller: pageborder,
                physics: const BouncingScrollPhysics(),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                    controller: pageborder,
                    effect: const ExpandingDotsEffect(
                        activeDotColor: primaryColor,
                        dotColor: Colors.grey,
                        dotHeight: 10,
                        spacing: 4,
                        dotWidth: 10,
                        expansionFactor: 5),
                    count: bording.length),
                const Spacer(),
                FloatingActionButton(
                  backgroundColor: primaryColor,
                  onPressed: () {
                    isLast
                        ? MM2()
                            // Chache()
                            //     .saveData(key: 'onBordering', value: true)
                            .then((value) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                                (route) => false);
                          })
                        : pageborder.nextPage(
                            duration: const Duration(milliseconds: 750),
                            curve: Curves.fastLinearToSlowEaseIn);
                  },
                  child: const Icon(Icons.arrow_forward_ios),
                )
              ],
            )
          ],
        ),
      ), //smooth_page_indicator
    );
  }

  Widget buildBoardingiItem(BordingModel model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
                height: 300,
                child: Image(
                  image: AssetImage(model.Image),
                  fit: BoxFit.cover,
                )),
          ),
          const SizedBox(
            height: 30,
          ),
          Text(model.Titel),
          const SizedBox(
            height: 15,
          ),
          Text(model.Body),
        ],
      );
}

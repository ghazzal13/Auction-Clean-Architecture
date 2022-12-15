import 'package:auction_clean_architecture/core/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    BordingModel('asset/image/border.1.jpg', 'You can bid at ', ' Auctions'),
    BordingModel('asset/image/add-border.2.jpg', 'Add your own ', ' Items'),
    BordingModel(
        'asset/image/border.2.jpg', 'And receive you items you win.', ' '),
  ];

  Future MM2() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('onBordering', true);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        automaticallyImplyLeading: true,
        actions: [
          TextButton(
            child: const Text(
              'skip',
              style: TextStyle(
                  fontSize: 25,
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
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  itemBuilder: (context, index) => buildBoardingiItem(
                    bording[index],
                    size,
                  ),
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
                  const SizedBox(
                    width: 10,
                  ),
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
                                      builder: (context) =>
                                          const LoginScreen()),
                                  (route) => false);
                            })
                          : pageborder.nextPage(
                              duration: const Duration(milliseconds: 750),
                              curve: Curves.fastLinearToSlowEaseIn);
                    },
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ), //smooth_page_indicator
    );
  }

  Widget buildBoardingiItem(
    BordingModel model,
    Size size,
  ) =>
      Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage(model.Image),
                  fit: BoxFit.cover,
                )),
            height: size.height * .8,
          ),
          SizedBox(
            height: size.height * .8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(.5),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Positioned(
            bottom: size.height * .20,
            left: 20,
            child: SizedBox(
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    model.Titel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    model.Body,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.yellow,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}

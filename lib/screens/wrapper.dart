import 'package:flutter/material.dart';
import 'package:ned/screens/authenticate/authenticate.dart';
import 'package:ned/screens/home/home.dart';
import 'package:ned/services/database.dart';
import 'package:provider/provider.dart';
import 'package:ned/models/user.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';

class Wrapper extends StatefulWidget {


  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {


  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    // return either home or authenticate
    if (user == null){
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
      );
      return OnBoardingPage();
    } else {
      return StreamProvider<List<UserBioData>>.value(
          value: DatabaseService().userDataForAdmin,
          child: NavDrawerExample()
      );
    }
  }
}

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();



  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('assets/$assetName.png', width: 350.0),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {

    void _onIntroEnd(context) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => Authenticate()),
      );
    }
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      //pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "WELCOME",
          body:
          "Attem, a complete package for students.",
          image: _buildImage('img1'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Manages Your Attendance",
          body:
          "Not to worry about Attendance anymore,\nlet Attem handle it.",
          image: _buildImage('img2'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Timetable on the Cloud",
          body:
          "Store your Timetable on the cloud and access it anytime on any phone.",
          image: _buildImage('img3'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Pocket Library",
          body: "Read Books without downloading, 500+ books ready to be read from the cloud",
          image: _buildImage('img4'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Personal Calculator",
          body: "Most essential tool for students specially for Engineers.",
          image: _buildImage('img5'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Enjoy along with Study",
          body: "Most famous game on the internet when the internet is not working.",
          image: _buildImage('img6'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Teach and Earn Money",
          body: 'Tuition are provided daily on first come first serve basis in the Teaching Portal.',
          image: _buildImage('img7'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      //globalBackgroundColor: Colors.white,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        //color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}

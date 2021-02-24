import 'dart:async';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'db.dart' as Database;

import 'package:flutter/material.dart';
import 'package:quiz_app/question.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

final questions = Database.fetchQuestions();

class _MyHomePageState extends State<MyHomePage> {
  var currentQuestionIndex = 0;
  final _maxSeconds = 10;
  int _remainedSeconds;
  Timer _timer;

  final backgroundImageUrl = "https://wallpaperaccess.com/full/126320.jpg";

  var gameStatus = GameStatus.START;

  void _startTimer() {
    _remainedSeconds = _maxSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainedSeconds > 0) {
        setState(() {
          _remainedSeconds--;
        });
      } else {
        _timer.cancel();
        gameOver();
      }
    });
  }

  @override
  void initState() {
    hideStatusBar();
    super.initState();
  }

  void hideStatusBar() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  }

  static const backgroundImage = AssetImage("images/background.png");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 64, horizontal: 24),
          width: double.infinity,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(blurRadius: 20)
          ], image: DecorationImage(fit: BoxFit.cover, image: backgroundImage)),
          child: getGameScreen()),
    );
  }

  Widget getGameScreen() {
    switch (gameStatus) {
      case GameStatus.START:
        return buildGameStartScreen();
      case GameStatus.GAMING:
        return buildGameScreen();
      case GameStatus.RESULT:
        return buildGameFinishScreen();
      default:
        throw Exception("UNDEFINED SCREEN");
    }
  }

  Widget buildGameStartScreen() {
    return Stack(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            "BİLGİ\nYARIŞMASI",
            style: GoogleFonts.aBeeZee(
                textStyle: TextStyle(
              fontSize: 48,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              height: 1.15,
              letterSpacing: 1.5,
              shadows: [
                Shadow(
                  blurRadius: 15.0,
                ),
              ],
            )),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: RaisedButton(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                //side: BorderSide(color: Colors.red),
              ),
              color: Colors.white,
              textColor: Theme.of(context).accentColor,
              child: Text(
                "OYUNA BAŞLA",
                style: GoogleFonts.poppins(
                    textStyle:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
              ),
              onPressed: () => startGame()),
        )
      ],
    );
  }

  Widget buildGameScreen() {
    return Container(
        child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
        child: getGameScreenContent(),
      ),
    ));
  }

  Widget getGameScreenContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            Expanded(
                child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 6),
                  child: Icon(
                    Icons.assistant_photo,
                    size: 16,
                  ),
                ),
                Text(
                  "${currentQuestionIndex + 1}/${questions.length}",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            )),
            buildTimeProgress(),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 6),
                  child: Icon(
                    Icons.article,
                    size: 16,
                  ),
                ),
                Text(
                  questions[currentQuestionIndex].topic,
                  //style: TextStyle(letterSpacing: 1.2),
                ),
              ],
            )),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (questions[currentQuestionIndex].imageFileName != null)
                  buildImage(),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    questions[currentQuestionIndex].content,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          height: 1.15),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        for (var i = 0; i < questions[currentQuestionIndex].choices.length; i++)
          buildAnswer(context, questions[currentQuestionIndex].choices[i], i),
      ],
    );
  }

  Widget buildReward() {
    return Expanded(
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(20)),
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(right: 6),
                  child: Icon(
                    Icons.card_giftcard,
                    color: Colors.white,
                    size: 16,
                  )),
              Text("\$150",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  )),
            ],
          )),
    );
  }

  Widget buildTimeProgress() {
    return Container(
      //color: Colors.amber,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: CircularProgressIndicator(
              value: _remainedSeconds / _maxSeconds,
              strokeWidth: 3,
              backgroundColor: Colors.grey[200],
            ),
          ),
          Text(
            "$_remainedSeconds",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Widget buildImage() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(questions[currentQuestionIndex].imageFileName),
            alignment: Alignment.center),
      ),
    );
  }

  Widget buildGameFinishScreen() {
    return Column(
      children: [],
    );
  }

  void startGame() {
    setState(() {
      gameStatus = GameStatus.GAMING;
      currentQuestionIndex = 0;
      shuffleChoicesIfNecessary();
      _startTimer();
    });
  }

  void onSelectAnswer(Answer answer) {
    //tıklanan buton rengi olacak
    //tıklanma engellenecek
    _timer?.cancel();
    if (answer.isCorrect)
      onCorrectAnswer();
    else
      onWrongAnswer();
  }

  void onCorrectAnswer() {
    if (currentQuestionIndex + 1 < questions.length)
      nextQuestion();
    else
      onAchieve();
  }

  void nextQuestion() {
    setState(() {
      currentQuestionIndex++;
      shuffleChoicesIfNecessary();
      _startTimer();
    });
  }

  void shuffleChoicesIfNecessary() {
    if (questions[currentQuestionIndex].isShuffled)
      questions[currentQuestionIndex].choices.shuffle();
  }

  void onAchieve() {
    //kazanma ekranı gelecek
  }

  void onWrongAnswer() => gameOver();

  gameOver() {
    print("Oyun bitti");
    //kaybetme ekranı gelecek
  }

  Widget buildAnswer(BuildContext context, Answer answer, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Ink(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(width: 2, color: Theme.of(context).accentColor)),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            onSelectAnswer(answer);
          },
          child: Container(
            padding: EdgeInsets.all(6),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 16),
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).accentColor,
                  ),
                  child: Text(
                    index == 0
                        ? "A"
                        : index == 1
                            ? "B"
                            : index == 2
                                ? "C"
                                : "D",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                Text(
                  answer.content,
                  style: GoogleFonts.poppins(
                    textStyle:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum GameStatus { START, GAMING, RESULT }

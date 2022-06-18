import 'dart:async';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/widget/quiz.dart';

import 'db.dart' as Database;

import 'package:flutter/material.dart';
import 'file:///C:/Users/tahak/AndroidStudioProjects/quiz_app/lib/model/question.dart';
import 'model/answer.dart';

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
  var currentQuestion = questions[0];

  var gameStatus = GameStatus.START;

  final _timeProgressKey = GlobalKey<TimeProgressState>();

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
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(blurRadius: 20)],
            image: DecorationImage(fit: BoxFit.cover, image: backgroundImage),
          ),
          child: buildScreen()),
    );
  }

  Widget buildScreen() {
    switch (gameStatus) {
      case GameStatus.START:
        return buildStartScreen();
      case GameStatus.GAMING:
        return buildGameScreen();
      case GameStatus.BREATHER:
        return buildBreatherScreen();
      case GameStatus.RESULT:
        return buildResultScreen();
      default:
        throw Exception("UNDEFINED SCREEN");
    }
  }

  Widget buildStartScreen() {
    return Stack(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            "BİLGİ\nYARIŞMASI",
            style: GoogleFonts.overpass(
              textStyle: TextStyle(
                fontSize: 48,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                height: 1.15,
                //letterSpacing: 1.5,
                shadows: [
                  Shadow(blurRadius: 10.0, offset: Offset(2.5, 5)),
                ],
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: RaisedButton(
            elevation: null,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              //side: BorderSide(color: Colors.red),
            ),
            color: Colors.white,
            textColor: Theme.of(context).primaryColor,
            child: Text(
              "OYUNA BAŞLA",
              style: GoogleFonts.poppins(
                  textStyle:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
            ),
            onPressed: () => startGame(),
          ),
        )
      ],
    );
  }

  Widget buildGameScreen() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
        child: Quiz(
          timeProgressKey: _timeProgressKey,
          currentQuestion: currentQuestion,
          currentQuestionIndex: currentQuestionIndex,
          questionCount: questions.length,
          onTimeUp: () => gameOver(),
          onSelectAnswer: (answer) => onSelectAnswer(answer),
        ),
      ),
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
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  )),
            ],
          )),
    );
  }

  Widget buildBreatherScreen() {
    return Container();
  }

  Widget buildResultScreen() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          child: Text(
            "$currentQuestionIndex/${questions.length}",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 32,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void startGame() {
    setState(() {
      gameStatus = GameStatus.GAMING;
      currentQuestionIndex = 0;
      shuffleChoicesIfNecessary();
    });
  }

  void onSelectAnswer(Answer answer) {
    _timeProgressKey.currentState.cancelTimer();

    setState(() {
      currentQuestion.choices.forEach((c) => c.isEnabled = false);
      answer.isSelected = true;
    });

    Future.delayed(Duration(seconds: 2), () => checkAnswer(answer));
  }

  void checkAnswer(Answer answer) {
    //burada doğru cevap yanıp sönecek
    //bu bir iki saniyelik yanıp sönme sonrası
    //cevap doğruysa paraların bulunduğu ekrana gidecek
    //yanlışsa sonuç ekranına gidecek

    setState(() {
      final correctChoice = currentQuestion.choices.firstWhere((c) => c.isCorrect);
      correctChoice.isBlink = true;
    });

    Future.delayed(Duration(seconds: 3), () {
      if (answer.isCorrect)
        onCorrectAnswer();
      else
        onWrongAnswer();
    });
  }

  void onCorrectAnswer() {
    if (++currentQuestionIndex < questions.length)
      nextQuestion();
    else
      onAchieve();
  }

  void changeToBreather(){
    setState(() {
      gameStatus = GameStatus.BREATHER;
    });
  }

  void nextQuestion() {
    setState(() {
      currentQuestion = questions[currentQuestionIndex];
      shuffleChoicesIfNecessary();
      _timeProgressKey.currentState.startTimer();
    });
  }

  void shuffleChoicesIfNecessary() {
    if (currentQuestion.isShuffled) currentQuestion.choices.shuffle();
  }

  void onAchieve() {
    //kazanma ekranı gelecek
    gameOver();
  }

  void onWrongAnswer() => gameOver();

  void gameOver() {
    print("Oyun bitti");
    setState(() => gameStatus = GameStatus.RESULT);
    //kaybetme ekranı gelecek
  }
}

enum GameStatus { START, GAMING, BREATHER, RESULT }

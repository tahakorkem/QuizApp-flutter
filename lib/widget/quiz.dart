import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/model/answer.dart';
import 'package:quiz_app/model/question.dart';
import 'package:quiz_app/widget/answer.dart';
import 'package:quiz_app/widget/question.dart';

class Quiz extends StatelessWidget {
  final Question currentQuestion;
  final int currentQuestionIndex;
  final int questionCount;
  final VoidCallback onTimeUp;
  final Function(Answer answer) onSelectAnswer;
  final GlobalKey<TimeProgressState> timeProgressKey;

  const Quiz({
    key: Key,
    @required this.currentQuestion,
    @required this.currentQuestionIndex,
    @required this.questionCount,
    this.onTimeUp,
    this.onSelectAnswer,
    this.timeProgressKey,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            _buildWhichQuestion(),
            TimeProgress(onTimeUp: onTimeUp, key: timeProgressKey),
            _buildQuestionTopic(),
          ],
        ),
        QuestionWidget(currentQuestion: currentQuestion),
        for (var i = 0; i < currentQuestion.choices.length; i++)
          AnswerWidget(
            answer: currentQuestion.choices[i],
            index: i,
            onSelectAnswer: onSelectAnswer,
          ),
      ],
    );
  }

  Widget _buildQuestionTopic() {
    return Expanded(
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
          currentQuestion.topic,
        ),
      ],
    ));
  }

  Widget _buildWhichQuestion() {
    return Expanded(
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
          "${currentQuestionIndex + 1}/$questionCount",
          textAlign: TextAlign.start,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    ));
  }
}

class TimeProgress extends StatefulWidget {
  final VoidCallback onTimeUp;

  const TimeProgress({this.onTimeUp, Key key}) : super(key: key);

  @override
  TimeProgressState createState() => TimeProgressState();
}

class TimeProgressState extends State<TimeProgress> {
  int _remainedSeconds;
  int _maxSeconds = 10;
  Timer _timer;

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  void startTimer() {
    _remainedSeconds = _maxSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainedSeconds - 1 > 0) {
        setState(() => _remainedSeconds--);
      } else {
        _timer.cancel();
        widget.onTimeUp();
      }
    });
  }

  void cancelTimer() => _timer?.cancel();

  @override
  Widget build(BuildContext context) {
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
            _remainedSeconds.toString(),
            style: GoogleFonts.poppins(
              textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/model/answer.dart';

import '../animation.dart';

class AnswerWidget extends StatelessWidget {
  final Answer answer;
  final int index;
  final Function(Answer answer) onSelectAnswer;

  AnswerWidget({
    @required this.answer,
    @required this.index,
    this.onSelectAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Choice(
        answer: answer,
        index: index,
        onSelectAnswer: onSelectAnswer,
      ),
    );
  }
}

class Choice extends StatefulWidget {
  final Answer answer;
  final int index;
  final Function(Answer answer) onSelectAnswer;

  const Choice({Key key, this.answer, this.index, this.onSelectAnswer})
      : super(key: key);

  @override
  _ChoiceState createState() => _ChoiceState();
}

const choiceLetters = ["A", "B", "C", "D", "E"];

class _ChoiceState extends State<Choice> with TickerProviderStateMixin {
  AnimationController _controller;
  Tween<double> _tween = Tween(begin: 0, end: 1);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    // ..timeout(Duration(milliseconds: 750*3), onTimeout: () {
    //   _controller.forward(from: 1);
    //   _controller.stop(canceled: true);
    // });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.answer.isBlink)
          buildAnimatedContainer(),
        Ink(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border:
                  Border.all(width: 2, color: Theme.of(context).primaryColor),
              color: widget.answer.isSelected
                  ? Theme.of(context).primaryColor
                  : null),
          child: InkWell(
            splashColor: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(24),
            onTap: widget.answer.isEnabled
                ? () => widget.onSelectAnswer(widget.answer)
                : null,
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
                      color: widget.answer.isSelected
                          ? Colors.transparent
                          : Theme.of(context).primaryColor,
                    ),
                    child: Text(
                      choiceLetters[widget.index],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    widget.answer.content,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: widget.answer.isSelected
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  FadeTransition buildAnimatedContainer() {
    _controller.repeat(reverse: true);

    return FadeTransition(
          opacity: _tween.animate(
            CurvedAnimation(
              parent: _controller,
              curve: BreathingCurve(),
            ),
          ),
          child: Container(
            height: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.green,
            ),
          ),
        );
  }
}

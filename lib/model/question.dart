import 'package:flutter/widgets.dart';
import 'answer.dart';

class Question {
  final String content;
  final String topic;
  final int difficultyLevel;
  final String imageFileName;
  final List<Answer> choices;
  final bool isShuffled;

  Question(this.content,
      {@required this.topic,
      @required this.difficultyLevel,
      this.imageFileName,
      @required this.choices,
      this.isShuffled = true});
}

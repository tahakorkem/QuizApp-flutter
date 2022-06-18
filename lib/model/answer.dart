
class Answer {
  final String content;
  final bool isCorrect;
  bool isSelected;
  bool isEnabled;
  bool isBlink;

  Answer(this.content, {this.isCorrect = false, this.isSelected = false, this.isEnabled = true, this.isBlink = false});
}

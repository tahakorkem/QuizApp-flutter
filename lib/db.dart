import 'model/answer.dart';
import 'model/question.dart';

List<Question> fetchQuestions() {
  return  [
    Question(
      "Yukarıdaki bayrak hangi ülkeye aittir?",
      topic: "Genel Kültür",
      difficultyLevel: 1,
      imageFileName:
          "images/japan_flag.jpg",
      choices: [
        Answer("Japonya", isCorrect: true),
        Answer("Çin"),
        Answer("Güney Kore"),
        Answer("Tayvan")
      ],
    ),
    Question(
      "Apple'ın ilk çıkardığı ürün aşağıdakilerden hangisidir?",
      topic: "Teknoloji",
      difficultyLevel: 1,
      choices: [
        Answer("iPhone"),
        Answer("iPad"),
        Answer("Apple I", isCorrect: true),
        Answer("iPod")
      ],
    ),
    Question(
      "Aşağıdaki takvimlerden hangisinin yeni yıl günü 1 Ocak'tır?",
      topic: "Tarih",
      difficultyLevel: 2,
      choices: [
        Answer("Julyen Takvimi", isCorrect: true),
        Answer("Gregoryen Takvimi"),
        Answer("Yahudi Takvimi"),
        Answer("Çin Takvimi")
      ],
      isShuffled: false,
    ),
  ];
}

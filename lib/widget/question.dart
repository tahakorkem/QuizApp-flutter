import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/model/question.dart';

class QuestionWidget extends StatelessWidget {

  final Question currentQuestion;

  const QuestionWidget({@required this.currentQuestion});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (currentQuestion.imageFileName != null) _buildImage(),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                currentQuestion.content,
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
    );
  }

  Widget _buildImage() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(currentQuestion.imageFileName),
            alignment: Alignment.center),
      ),
    );
  }

}

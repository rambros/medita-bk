class Question {
  final String questionTitle;
  final List options;
  final int correctAnswerIndex;

  Question({
    required this.questionTitle,
    required this.options,
    required this.correctAnswerIndex,
  });

  factory Question.fromMap(Map<String, dynamic> d) {
    return Question(
      questionTitle: d['question'],
      options: d['options'],
      correctAnswerIndex: d['correct_ans_index'],
    );
  }

  static Map<String, dynamic> getMap (Question d){
    return {
      'question': d.questionTitle,
      'options': d.options,
      'correct_ans_index': d.correctAnswerIndex,
    };
  }
}
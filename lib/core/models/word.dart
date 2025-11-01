class Word {
  String date = ""; // 日期
  String _word = ""; // 英文單字
  String _wordCN = ""; // 單字中文
  String _kk = ""; // kk 音標
  String _exampleSentences = "";
  String _exampleSentencesCN = "";
  String _note = "";
  int practiceTimes = 0;
  double practiceAcc = 0.0;
  int testTimes = 0;
  double testAcc = 0.0;


  // 建構子
  Word(String word, String wordCN) {
    this._word = word;
    this._wordCN = wordCN;
  }

  // Getter
  String get note => _note;
  String get exampleSentencesCN => _exampleSentencesCN;
  String get exampleSentences => _exampleSentences;
  String get kk => _kk;
  String get wordCN => _wordCN;
  String get word => _word;


  // Setter
  set note(String value) {
    _note = value;
  }

  set kk(String value) {
    _kk = value;
  }

  set wordCN(String value) {
    _wordCN = value;
  }

  set word(String value) {
    _word = value;
  }

  set exampleSentencesCN(String value) {
    _exampleSentencesCN = value;
  }

  set exampleSentences(String value) {
    _exampleSentences = value;
  }
}
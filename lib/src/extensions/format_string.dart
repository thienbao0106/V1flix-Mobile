 const double percentWord = 60;

extension StringExtension on String {
  String capitalize() {
    if(length == 0) return "";
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
  String truncate({required double screenWidth, required int line}) {
    if(screenWidth == 0) return "";
    /*Temp formula*/
    int wordNum = int.parse(((screenWidth / 2 - 15) * percentWord / 200).toStringAsFixed(0)) * line;
    if(wordNum >= length) return this;
    return "${substring(0, wordNum)}...";
  }
}
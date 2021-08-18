abstract class PredictiveListDataManager {
  final List<String> dataList = [];
  List<String> getSuggestions(String query);
  String? validate(String? value);
}

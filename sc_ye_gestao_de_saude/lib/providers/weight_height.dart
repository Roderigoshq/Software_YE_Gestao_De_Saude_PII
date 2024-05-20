import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sc_ye_gestao_de_saude/models/weight_height_model.dart';

class WeightHeightProvider extends ChangeNotifier {
  List<WeightHeightModel> _weightHeightList = [];

  List<WeightHeightModel> get weightHeightList => _weightHeightList;

  void deleteWeightHeight(String id) {
    _weightHeightList.removeWhere((item) => item.id == id);
    notifyListeners(); // Notifica os ouvintes sobre a mudança
  }
}


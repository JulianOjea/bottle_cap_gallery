import 'package:bottle_cap_gallery/src/business_logic/assets/list_iface.dart';

class DrinkService implements PredictiveListDataManager {
  final List<String> dataList = [
    'Aguardiente',
    'Alcopop',
    'Cava',
    'Pisco',
    'Tequila',
    'Vodka',
    'Whisky',
    'Agua',
    'Agua saborizada',
    'Aperitivos',
    'Bebida energética',
    'Café',
    'Cerveza',
    'Champán',
    'Cognac y Brandy',
    'Gaseosa',
    'Ginebra',
    'Jarabe',
    'Kvas',
    'Leche',
    'Licor',
    'Malta',
    'Oporto y Vino Fortificado',
    'Promocional',
    'Ron',
    'Salsa',
    'Sidra',
    'Té',
    'Vino',
    'Vino Espumoso',
    'Yogur',
    'Zumo',
  ];

  List<String> getSuggestions(String query) {
    if (query != "") {
      List<String> matches = <String>[];
      matches.addAll(dataList);

      matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
      return matches;
    } else
      return [];
  }
}

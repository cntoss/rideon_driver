import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class SearchProvider extends ChangeNotifier {
  static SearchProvider of(BuildContext context, {bool listen = true}) =>
      Provider.of<SearchProvider>(context, listen: listen);

  String prevSearchTerm = "";
  String searchTerm = "";
}

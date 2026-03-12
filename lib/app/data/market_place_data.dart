import 'dart:convert';

import 'package:get_storage/get_storage.dart';

import '../config/constants/app_storage.dart';
import '../models/marketplace_product.dart';

class MarketPlaceData {
  late final GetStorage _getStorage;
  MarketPlaceData() {
    _getStorage = GetStorage();
  }

  void saveUserCartData(MarketPlaceProduct productModel) {
    List<MarketPlaceProduct>? marketModelList = getUserCartData();
    marketModelList = marketModelList ?? [];
    marketModelList.add(productModel);
    List josnList = marketModelList.map((e) => e.toJson()).toList();
    _getStorage.write(AppStorage.ADD_CART_KEY, josnList);
  }

  String renderModelToJson(List<MarketPlaceProduct> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  List<MarketPlaceProduct>? getUserCartData() {
    if (_getStorage.read(AppStorage.ADD_CART_KEY) != null) {
      List josnList = _getStorage.read(AppStorage.ADD_CART_KEY);
      List<MarketPlaceProduct> productList =
          josnList.map((e) => MarketPlaceProduct.fromJson(e)).toList();

      return productList;
    } else {
      return null;
    }
  }
}

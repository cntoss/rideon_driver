import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rideon_driver/config/appConfig.dart';
import 'package:rideon_driver/models/savedAddress/addressType.dart';
import 'package:rideon_driver/models/savedAddress/savedAddressModel.dart';
import 'package:rideon_driver/services/helper/hiveService.dart';

class SavedAddressService {
  Box _box = HiveService().getHiveBox();

  void saveAddress({required SavedAddressModel savedAddressModel}) {
    List<SavedAddressModel> _list = getSavedAddress();
    _list.add(savedAddressModel);
    _box.put(hkAddressType, _list);
  }

  void editAddress({required SavedAddressModel savedAddressModel}) {
    List<SavedAddressModel> _list = getSavedAddress();
    _list.removeWhere((element) => element.id == savedAddressModel.id);
    _list.add(savedAddressModel);
    _box.put(hkAddressType, _list);
  }

  void deleteAddress({required SavedAddressModel savedAddressModel}) {
    List<SavedAddressModel> _list = getSavedAddress();
    _list.removeWhere((element) => element.id == savedAddressModel.id);
    _box.put(hkAddressType, _list);
  }

  List<SavedAddressModel> getSavedAddress() {
    List<SavedAddressModel> _list = <SavedAddressModel>[];
    List<dynamic> result = _box.get(
      hkAddressType,
      defaultValue: <SavedAddressModel>[],
    );
    _list = result.cast();
    return _list;
  }

  SavedAddressModel getSingleAddress(AddressType type) {
    List<SavedAddressModel> _list = <SavedAddressModel>[];
    List<dynamic> result = _box.get(
      hkAddressType,
      defaultValue: <SavedAddressModel>[],
    );
    _list = result.cast();
    return _list.where((e) => e.type == type).length != 0
        ? _list.where((e) => e.type == type).first
        : SavedAddressModel();
  }

}

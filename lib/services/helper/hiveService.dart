import 'dart:convert';


import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rideon_driver/config/appConfig.dart';
import 'package:rideon_driver/models/savedAddress/addressType.dart';
import 'package:rideon_driver/models/savedAddress/savedAddressModel.dart';
import 'package:rideon_driver/models/user/userModel.dart';

class HiveService {
  Future<Box> initHive() async {
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    var hasEncryptionKey =
        await secureStorage.containsKey(key: hkEncryptionKey);
    if (!hasEncryptionKey) {
      var key = Hive.generateSecureKey();
      await secureStorage.write(
          key: hkEncryptionKey, value: base64UrlEncode(key));
    }
    var encryptionKey =
        base64Url.decode(await secureStorage.read(key: hkEncryptionKey));
    if (!Hive.isBoxOpen(hiveBoxName)) {
      await Hive.initFlutter();
      _registerTypeAdapters();
      Box hiveBox = await Hive.openBox(hiveBoxName,
          compactionStrategy: (entries, deletedEntries) {
        return deletedEntries > 20;
      }, encryptionCipher: HiveAesCipher(encryptionKey));
      return hiveBox;
    } else {
      return getHiveBox();
    }
  }

  void _registerTypeAdapters() {
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(SavedAddressModelAdapter());
    Hive.registerAdapter(AddressTypeAdapter());
    Hive.registerAdapter(LnModelAdapter());
  
  }

  Box getHiveBox() {
    return Hive.box(hiveBoxName);
  }
}

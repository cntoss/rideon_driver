import 'package:hive/hive.dart';
import 'package:rideon_driver/config/appConfig.dart';

part 'addressType.g.dart';

@HiveType(typeId: htAddressType)
enum AddressType {
  @HiveField(0)
  Home,
  @HiveField(1)
  Work,
  @HiveField(2)
  Other,
}

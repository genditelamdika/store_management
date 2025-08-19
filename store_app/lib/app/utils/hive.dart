import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

void DataHive() async {
  WidgetsFlutterBinding.ensureInitialized();

   final appDocDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocDir.path);

  await Hive.openBox('appData');  
   await Hive.openBox('PromoStore');  
  await Hive.openBox('PendingProductReport');
   await Hive.openBox('PendingPromoStore');
  await Hive.openBox('reports');  
}
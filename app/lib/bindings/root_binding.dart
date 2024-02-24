import 'package:earth_and_i/bindings/home_binding.dart';
import 'package:earth_and_i/bindings/load_map_binding.dart';
import 'package:earth_and_i/bindings/profile_binding.dart';
import 'package:earth_and_i/view_models/root/root_view_model.dart';
import 'package:get/get.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RootViewModel>(() => RootViewModel());

    LoadMapBinding().dependencies();
    HomeBinding().dependencies();
    ProfileBinding().dependencies();
  }
}

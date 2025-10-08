import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:qarsspin/model/global_model.dart';
import 'const/base_url.dart';

class MySearchController extends GetxController {
  List<GlobalModel> makes = [];
  List<GlobalModel> classes = [];
  List<GlobalModel> types = [];
  List<GlobalModel> models = [];

  @override
  void onInit() {
    print("initit");
    super.onInit();
    fetchCarMakes(); // أول لست تتحمّل مع فتح الفورم
  }

  fetchCarMakes({String sort = "MakeName"}) async {
    print("callllmakes");

    final url = Uri.parse(
      '$base_url/BrowsingRelatedApi.asmx/GetListOfCarMakes?Order_By=$sort',
    );

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final parsedJson = jsonDecode(response.body);
      final List<dynamic> data = parsedJson['Data'];

      makes = data
          .map((e) => GlobalModel(
        id: e["Make_ID"],
        name: e["Make_Name_PL"],
      ))
          .toList();

      update(); // هنا يحدّث الـ GetBuilder
    }
  }

  fetchClasses(makeId) async {
    classes.clear();

    final url = Uri.parse(
      '$base_url/BrowsingRelatedApi.asmx/GetListOfCarClasses?Make_ID=$makeId',
    );

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final parsedJson = jsonDecode(response.body);
      final data = parsedJson['Data'];

      classes = data
          .map<GlobalModel>((e) => GlobalModel(
        id: e["Class_ID"],
        name: e["Class_Name_PL"],
      )).toList();

      update();
    }
  }

  fetchModels(classId) async {
    models = [];

    final url = Uri.parse(
      '$base_url/BrowsingRelatedApi.asmx/GetListOfCarModels?Class_ID=$classId',
    );

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final parsedJson = jsonDecode(response.body);
      final data = parsedJson['Data'];

      models = data
          .map<GlobalModel>((e) => GlobalModel(
        id: e["Model_ID"],
        name: e["Model_Name_PL"],
      ))
          .toList();
      fetchCategories();

      update();
    }
  }

  fetchCategories() async {
    types.clear();

    final url = Uri.parse(
      '$base_url/BrowsingRelatedApi.asmx/GetListOfCarCategories',
    );

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final parsedJson = jsonDecode(response.body);
      final data = parsedJson['Data'];

      types = data
          .map<GlobalModel>((e) => GlobalModel(
        id: e["Category_ID"],
        name: e["Category_Name_PL"],
      ))
          .toList();

      update();
    }
  }
}

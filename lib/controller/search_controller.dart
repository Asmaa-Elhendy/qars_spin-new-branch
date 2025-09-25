
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:qarsspin/controller/brand_controller.dart';
import 'package:qarsspin/model/global_model.dart';

import 'const/base_url.dart';

class MySearchController extends GetxController{
  List<GlobalModel> makes = [];
  List<GlobalModel> classes = [];
  List<GlobalModel> types = [];
  List<GlobalModel> model = [];

  fetchCarMakes({String sort = "MakeName"}) async {
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
      final body = response.body;
      final parsedJson = jsonDecode(body);
      final List<dynamic> data = parsedJson['Data'];
      for(int i =0; i<data.length;i++){
        makes.add(GlobalModel(
            id:data[i]["Make_ID"] ,
            name: data[i]["Make_Name_PL"]));
      }

      update();

    }




  }
  fetchClasses(makeId)async{
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
      final body = response.body;
      final parsedJson = jsonDecode(body);
      final  data = parsedJson['Data'];

      for(int i =0; i<data.length;i++){
        classes.add(GlobalModel(
            id:data[i]["Class_ID"] ,
            name: data[i]["Class_Name_PL"]));
        print(data);
      }

      update();
    }



  }
  fetchModels(classId)async{
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
      final body = response.body;
      final parsedJson = jsonDecode(body);
      final  data = parsedJson['Data'];
      fetchCategories();

      for(int i =0; i<data.length;i++){
        model.add(GlobalModel(
            id:data[i]["Model_ID"] ,
            name: data[i]["Model_Name_PL"]));
        print(data);
      }

      update();
    }


  }
  fetchCategories()async{
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
      final body = response.body;
      final parsedJson = jsonDecode(body);
      final  data = parsedJson['Data'];
      for(int i =0; i<data.length;i++){
        types.add(GlobalModel(
            id:data[i]["Category_ID"] ,
            name: data[i]["Category_Name_PL"]));
      }
    }
    update();

  }
// search({ String myCase = "sale"})async{
//   switch(myCase){
//     case "sale":
//       Get.find<BrandController>().
//   }

// }


}
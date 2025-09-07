
import 'package:get/get.dart';
import 'package:qarsspin/model/specs.dart';

class SpecsController extends GetxController{

  List<Specs> adSpecs = [
    Specs(id: 1, name: "Cylinder", hidden: true),
    Specs(id: 2, name: "Seats Type", hidden: true),
    Specs(id: 3, name: "Slide Roof", hidden: true),
    Specs(id: 4, name: "Park Sensors", hidden: true),
    Specs(id: 5, name: "Camera", hidden: true),
    Specs(id: 6, name: "Bluetooth", hidden: true),
    Specs(id: 7, name: "GPS", hidden: true),
    Specs(id: 8, name: "Engine Power", hidden: true),
    Specs(id: 9, name: "Torque", hidden: true),
    Specs(id: 10, name: "Interior Color", hidden: true),
    Specs(id: 11, name: "Fuel Type", hidden: true),
    Specs(id: 12, name: "Transmission", hidden: true),
    Specs(id: 13, name: "DriveTrain", hidden: true),
    Specs(id: 14, name: "Upholstery Material", hidden: true),
    Specs(id: 15, name: "Infotainment Screen Size", hidden: true),

  ];

  deleteSpecs(int id){
    adSpecs.removeWhere((item) => item.id == id);
    update();

  }
  editName(int id, String newName){
      final item = adSpecs.firstWhere(
            (p) => p.id == id,
        orElse: () => throw Exception("Product with id $id not found"),
      );
      item.name = newName;
      update();
  }
}
import 'dart:ui';

class RentalCar {
  final int postId;
  final String countryCode;
  final String postCode;
  final String postKind;
  final String postStatus;
  final int pinToTop;
  final String tag;
  final String sourceKind;
  final int partnerId;
  final String userName;
  final String? rectangleImageUrl;
  final String? rectangleImageFileName;
  final String? squareImageUrl;
  final String? squareImageFileName;
  final String? videoFileName;
  final String? videoUrl;
  final String? spin360Url;
  final String createdBy;
  final String createdDateTime;
  final String expirationDate;
  final String approvedBy;
  final String approvedDateTime;
  final String? rejectedBy;
  final String rejectedDateTime;
  final String? rejectedReason;
  final String? suspendedBy;
  final String suspendedDateTime;
  final String? suspendedReason;
  final String? archivedBy;
  final String archivedDateTime;
  final String? archivedReason;
  final int visitsCount;
  final int carId;
  final int categoryId;
  final String categoryNamePL;
  final String categoryNameSL;
  final int makeId;
  final int classId;
  final int modelId;
  final String carNamePL;
  final String carNameSL;
  final String carNameWithYearPL;
  final String carNameWithYearSL;
  final int manufactureYear;
  final String plateNumber;
  final String chassisNumber;
  final String technicalDescriptionPL;
  final String technicalDescriptionSL;
  final int mileage;
  final Color colorInterior;
  final String interiorColorNamePL;
  final String interiorColorNameSL;
  final Color colorExterior;
  final String exteriorColorNamePL;
  final String exteriorColorNameSL;
  final int isReadyForRent;
  final String internalRemarks;
  final int availableForDailyRent;
  final String rentPerDay;
  final int availableForWeeklyRent;
  final String rentPerWeek;
  final int availableForMonthlyRent;
  final String rentPerMonth;
  final int availableForLease;
  final String ownerName;
  final String ownerMobile;

  RentalCar({
    required this.postId,
    required this.countryCode,
    required this.postCode,
    required this.postKind,
    required this.postStatus,
    required this.pinToTop,
    required this.tag,
    required this.sourceKind,
    required this.partnerId,
    required this.userName,
    this.rectangleImageUrl,
    this.rectangleImageFileName,
    this.squareImageUrl,
    this.squareImageFileName,
    this.videoFileName,
    this.videoUrl,
    this.spin360Url,
    required this.createdBy,
    required this.createdDateTime,
    required this.expirationDate,
    required this.approvedBy,
    required this.approvedDateTime,
    this.rejectedBy,
    required this.rejectedDateTime,
    this.rejectedReason,
    this.suspendedBy,
    required this.suspendedDateTime,
    this.suspendedReason,
    this.archivedBy,
    required this.archivedDateTime,
    this.archivedReason,
    required this.visitsCount,
    required this.carId,
    required this.categoryId,
    required this.categoryNamePL,
    required this.categoryNameSL,
    required this.makeId,
    required this.classId,
    required this.modelId,
    required this.carNamePL,
    required this.carNameSL,
    required this.carNameWithYearPL,
    required this.carNameWithYearSL,
    required this.manufactureYear,
    required this.plateNumber,
    required this.chassisNumber,
    required this.technicalDescriptionPL,
    required this.technicalDescriptionSL,
    required this.mileage,
    required this.colorInterior,
    required this.interiorColorNamePL,
    required this.interiorColorNameSL,
    required this.colorExterior,
    required this.exteriorColorNamePL,
    required this.exteriorColorNameSL,
    required this.isReadyForRent,
    required this.internalRemarks,
    required this.availableForDailyRent,
    required this.rentPerDay,
    required this.availableForWeeklyRent,
    required this.rentPerWeek,
    required this.availableForMonthlyRent,
    required this.rentPerMonth,
    required this.availableForLease,
    required this.ownerName,
    required this.ownerMobile,
  });

  factory RentalCar.fromJson(Map<String, dynamic> json) {
    return RentalCar(
      postId: json['Post_ID'] ?? 0,
      countryCode: json['Country_Code'] ?? '',
      postCode: json['Post_Code'] ?? '',
      postKind: json['Post_Kind'] ?? '',
      postStatus: json['Post_Status'] ?? '',
      pinToTop: json['Pin_To_Top'] ?? 0,
      tag: json['Tag'] ?? '',
      sourceKind: json['Source_Kind'] ?? '',
      partnerId: json['Partner_ID'] ?? 0,
      userName: json['UserName'] ?? '',
      rectangleImageUrl: json['Rectangle_Image_URL'],
      rectangleImageFileName: json['Rectangle_Image_FileName'],
      squareImageUrl: json['Square_Image_URL'],
      squareImageFileName: json['Square_Image_FileName'],
      videoFileName: json['Video_FileName'],
      videoUrl: json['Video_URL'],
      spin360Url: json['Spin360_URL'],
      createdBy: json['Created_By'] ?? '',
      createdDateTime: json['Created_DateTime'] ?? '',
      expirationDate: json['Expiration_Date'] ?? '',
      approvedBy: json['Approved_By'] ?? '',
      approvedDateTime: json['Approved_DateTime'] ?? '',
      rejectedBy: json['Rejected_By'],
      rejectedDateTime: json['Rejected_DateTime'] ?? '',
      rejectedReason: json['Rejected_Reason'],
      suspendedBy: json['Suspended_By'],
      suspendedDateTime: json['Suspended_DateTime'] ?? '',
      suspendedReason: json['Suspended_Reason'],
      archivedBy: json['Archived_By'],
      archivedDateTime: json['Archived_DateTime'] ?? '',
      archivedReason: json['Archived_Reason'],
      visitsCount: json['Visits_Count'] ?? 0,
      carId: json['Car_ID'] ?? 0,
      categoryId: json['Category_ID'] ?? 0,
      categoryNamePL: json['Category_Name_PL'] ?? '',
      categoryNameSL: json['Category_Name_SL'] ?? '',
      makeId: json['Make_ID'] ?? 0,
      classId: json['Class_ID'] ?? 0,
      modelId: json['Model_ID'] ?? 0,
      carNamePL: json['Car_Name_PL'] ?? '',
      carNameSL: json['Car_Name_SL'] ?? '',
      carNameWithYearPL: json['Car_Name_With_Year_PL'] ?? '',
      carNameWithYearSL: json['Car_Name_With_Year_SL'] ?? '',
      manufactureYear: json['Manufacture_Year'] ?? 0,
      plateNumber: json['Plate_Number'] ?? '',
      chassisNumber: json['Chassis_Number'] ?? '',
      technicalDescriptionPL: json['Technical_Description_PL'] ?? '',
      technicalDescriptionSL: json['Technical_Description_SL'] ?? '',
      mileage: json['Mileage'] ?? 0,
      colorInterior: json['Color_Interior'] ?? '',
      interiorColorNamePL: json['Interior_Color_Name_PL'] ?? '',
      interiorColorNameSL: json['Interior_Color_Name_SL'] ?? '',
      colorExterior: json['Color_Exterior'] ?? '',
      exteriorColorNamePL: json['Exterior_Color_Name_PL'] ?? '',
      exteriorColorNameSL: json['Exterior_Color_Name_SL'] ?? '',
      isReadyForRent: json['isReady_For_Rent'] ?? 0,
      internalRemarks: json['Internal_Remarks'] ?? '',
      availableForDailyRent: json['Available_For_Daily_Rent'] ?? 0,
      rentPerDay: json['Rent_Per_Day'] ?? '0.0',
      availableForWeeklyRent: json['Available_For_Weekly_Rent'] ?? 0,
      rentPerWeek: json['Rent_Per_Week'] ?? '0.0',
      availableForMonthlyRent: json['Available_For_Monthly_Rent'] ?? 0,
      rentPerMonth: json['Rent_Per_Month'] ?? '0.0',
      availableForLease: json['Available_For_Lease'] ?? 0,
      ownerName: json['Owner_Name'] ?? '',
      ownerMobile: json['Owner_Mobile'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Post_ID": postId,
      "Country_Code": countryCode,
      "Post_Code": postCode,
      "Post_Kind": postKind,
      "Post_Status": postStatus,
      "Pin_To_Top": pinToTop,
      "Tag": tag,
      "Source_Kind": sourceKind,
      "Partner_ID": partnerId,
      "UserName": userName,
      "Rectangle_Image_URL": rectangleImageUrl,
      "Rectangle_Image_FileName": rectangleImageFileName,
      "Square_Image_URL": squareImageUrl,
      "Square_Image_FileName": squareImageFileName,
      "Video_FileName": videoFileName,
      "Video_URL": videoUrl,
      "Spin360_URL": spin360Url,
      "Created_By": createdBy,
      "Created_DateTime": createdDateTime,
      "Expiration_Date": expirationDate,
      "Approved_By": approvedBy,
      "Approved_DateTime": approvedDateTime,
      "Rejected_By": rejectedBy,
      "Rejected_DateTime": rejectedDateTime,
      "Rejected_Reason": rejectedReason,
      "Suspended_By": suspendedBy,
      "Suspended_DateTime": suspendedDateTime,
      "Suspended_Reason": suspendedReason,
      "Archived_By": archivedBy,
      "Archived_DateTime": archivedDateTime,
      "Archived_Reason": archivedReason,
      "Visits_Count": visitsCount,
      "Car_ID": carId,
      "Category_ID": categoryId,
      "Category_Name_PL": categoryNamePL,
      "Category_Name_SL": categoryNameSL,
      "Make_ID": makeId,
      "Class_ID": classId,
      "Model_ID": modelId,
      "Car_Name_PL": carNamePL,
      "Car_Name_SL": carNameSL,
      "Car_Name_With_Year_PL": carNameWithYearPL,
      "Car_Name_With_Year_SL": carNameWithYearSL,
      "Manufacture_Year": manufactureYear,
      "Plate_Number": plateNumber,
      "Chassis_Number": chassisNumber,
      "Technical_Description_PL": technicalDescriptionPL,
      "Technical_Description_SL": technicalDescriptionSL,
      "Mileage": mileage,
      "Color_Interior": colorInterior,
      "Interior_Color_Name_PL": interiorColorNamePL,
      "Interior_Color_Name_SL": interiorColorNameSL,
      "Color_Exterior": colorExterior,
      "Exterior_Color_Name_PL": exteriorColorNamePL,
      "Exterior_Color_Name_SL": exteriorColorNameSL,
      "isReady_For_Rent": isReadyForRent,
      "Internal_Remarks": internalRemarks,
      "Available_For_Daily_Rent": availableForDailyRent,
      "Rent_Per_Day": rentPerDay,
      "Available_For_Weekly_Rent": availableForWeeklyRent,
      "Rent_Per_Week": rentPerWeek,
      "Available_For_Monthly_Rent": availableForMonthlyRent,
      "Rent_Per_Month": rentPerMonth,
      "Available_For_Lease": availableForLease,
      "Owner_Name": ownerName,
      "Owner_Mobile": ownerMobile,
    };
  }
}

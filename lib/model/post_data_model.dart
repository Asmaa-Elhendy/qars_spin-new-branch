class PostDataModel {
  String? code;
  String? desc;
  int? count;
  List<PostData>? data;

  PostDataModel({
    this.code,
    this.desc,
    this.count,
    this.data,
  });

  PostDataModel.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    desc = json['Desc'];
    count = json['Count'];
    if (json['Data'] != null) {
      data = <PostData>[];
      json['Data'].forEach((v) {
        data!.add(PostData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Code'] = code;
    data['Desc'] = desc;
    data['Count'] = count;
    if (this.data != null) {
      data['Data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PostData {
  int? postId;
  String? countryCode;
  String? postCode;
  String? postKind;
  String? postStatus;
  int? pinToTop;
  String? tag;
  String? sourceKind;
  int? partnerId;
  String? userName;
  String? rectangleImageUrl;
  String? rectangleImageFileName;
  String? squareImageUrl;
  String? squareImageFileName;
  String? videoFileName;
  String? videoUrl;
  String? spin360Url;
  String? approvedDateTime;
  int? visitsCount;
  int? biddersCount;
  int? offersCount;
  String? highestPrice;
  int? carId;
  int? categoryId;
  String? categoryNamePl;
  String? categoryNameSl;
  int? makeId;
  String? makeNamePl;
  String? makeNameSl;
  int? classId;
  String? classNamePl;
  String? classNameSl;
  int? modelId;
  String? modelNamePl;
  String? modelNameSl;
  String? carNamePl;
  String? carNameSl;
  String? carNameWithYearPl;
  String? carNameWithYearSl;
  int? manufactureYear;
  String? plateNumber;
  String? chassisNumber;
  String? technicalDescriptionPl;
  String? technicalDescriptionSl;
  String? chassisNumber1;
  String? plateNumber1;
  int? mileage;
  int? warrantyIsAvailable;
  String? colorInterior;
  String? interiorColorNamePl;
  String? interiorColorNameSl;
  String? colorExterior;
  String? exteriorColorNamePl;
  String? exteriorColorNameSl;
  int? isReadyForSale;
  String? internalRemarks;
  int? inspectionReportIsAvailable;
  String? inspectionReportFileName;
  String? inspectionReportUrl;
  String? inspectionReportDate;
  String? askingPrice;
  String? minimumPrice;
  int? isBiddingEnabled;
  int? isSold;
  int? inspectionReportIsBought;
  int? isFavorite;

  PostData({
    this.postId,
    this.countryCode,
    this.postCode,
    this.postKind,
    this.postStatus,
    this.pinToTop,
    this.tag,
    this.sourceKind,
    this.partnerId,
    this.userName,
    this.rectangleImageUrl,
    this.rectangleImageFileName,
    this.squareImageUrl,
    this.squareImageFileName,
    this.videoFileName,
    this.videoUrl,
    this.spin360Url,
    this.approvedDateTime,
    this.visitsCount,
    this.biddersCount,
    this.offersCount,
    this.highestPrice,
    this.carId,
    this.categoryId,
    this.categoryNamePl,
    this.categoryNameSl,
    this.makeId,
    this.makeNamePl,
    this.makeNameSl,
    this.classId,
    this.classNamePl,
    this.classNameSl,
    this.modelId,
    this.modelNamePl,
    this.modelNameSl,
    this.carNamePl,
    this.carNameSl,
    this.carNameWithYearPl,
    this.carNameWithYearSl,
    this.manufactureYear,
    this.plateNumber,
    this.chassisNumber,
    this.technicalDescriptionPl,
    this.technicalDescriptionSl,
    this.chassisNumber1,
    this.plateNumber1,
    this.mileage,
    this.warrantyIsAvailable,
    this.colorInterior,
    this.interiorColorNamePl,
    this.interiorColorNameSl,
    this.colorExterior,
    this.exteriorColorNamePl,
    this.exteriorColorNameSl,
    this.isReadyForSale,
    this.internalRemarks,
    this.inspectionReportIsAvailable,
    this.inspectionReportFileName,
    this.inspectionReportUrl,
    this.inspectionReportDate,
    this.askingPrice,
    this.minimumPrice,
    this.isBiddingEnabled,
    this.isSold,
    this.inspectionReportIsBought,
    this.isFavorite,
  });

  PostData.fromJson(Map<String, dynamic> json) {
    postId = json['Post_ID'];
    countryCode = json['Country_Code'];
    postCode = json['Post_Code'];
    postKind = json['Post_Kind'];
    postStatus = json['Post_Status'];
    pinToTop = json['Pin_To_Top'];
    tag = json['Tag'];
    sourceKind = json['Source_Kind'];
    partnerId = json['Partner_ID'];
    userName = json['UserName'];
    rectangleImageUrl = json['Rectangle_Image_URL'];
    rectangleImageFileName = json['Rectangle_Image_FileName'];
    squareImageUrl = json['Square_Image_URL'];
    squareImageFileName = json['Square_Image_FileName'];
    videoFileName = json['Video_FileName'];
    videoUrl = json['Video_URL'];
    spin360Url = json['Spin360_URL'];
    approvedDateTime = json['Approved_DateTime'];
    visitsCount = json['Visits_Count'];
    biddersCount = json['Bidders_Count'];
    offersCount = json['Offers_Count'];
    highestPrice = json['Highest_Price'];
    carId = json['Car_ID'];
    categoryId = json['Category_ID'];
    categoryNamePl = json['Category_Name_PL'];
    categoryNameSl = json['Category_Name_SL'];
    makeId = json['Make_ID'];
    makeNamePl = json['Make_Name_PL'];
    makeNameSl = json['Make_Name_SL'];
    classId = json['Class_ID'];
    classNamePl = json['Class_Name_PL'];
    classNameSl = json['Class_Name_SL'];
    modelId = json['Model_ID'];
    modelNamePl = json['Model_Name_PL'];
    modelNameSl = json['Model_Name_SL'];
    carNamePl = json['Car_Name_PL'];
    carNameSl = json['Car_Name_SL'];
    carNameWithYearPl = json['Car_Name_With_Year_PL'];
    carNameWithYearSl = json['Car_Name_With_Year_SL'];
    manufactureYear = json['Manufacture_Year'];
    plateNumber = json['Plate_Number'];
    chassisNumber = json['Chassis_Number'];
    technicalDescriptionPl = json['Technical_Description_PL'];
    technicalDescriptionSl = json['Technical_Description_SL'];
    chassisNumber1 = json['Chassis_Number1'];
    plateNumber1 = json['Plate_Number1'];
    mileage = json['Mileage'];
    warrantyIsAvailable = json['Warranty_isAvailable'];
    colorInterior = json['Color_Interior'];
    interiorColorNamePl = json['Interior_Color_Name_PL'];
    interiorColorNameSl = json['Interior_Color_Name_SL'];
    colorExterior = json['Color_Exterior'];
    exteriorColorNamePl = json['Exterior_Color_Name_PL'];
    exteriorColorNameSl = json['Exterior_Color_Name_SL'];
    isReadyForSale = json['isReady_For_Sale'];
    internalRemarks = json['Internal_Remarks'];
    inspectionReportIsAvailable = json['Inspection_Report_isAvailable'];
    inspectionReportFileName = json['Inspection_Report_FileName'];
    inspectionReportUrl = json['Inspection_Report_URL'];
    inspectionReportDate = json['Inspection_Report_Date'];
    askingPrice = json['Asking_Price'];
    minimumPrice = json['Minimum_Price'];
    isBiddingEnabled = json['Is_Bidding_Enabled'];
    isSold = json['isSold'];
    inspectionReportIsBought = json['Inspection_Report_isBought'];
    isFavorite = json['isFavorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Post_ID'] = postId;
    data['Country_Code'] = countryCode;
    data['Post_Code'] = postCode;
    data['Post_Kind'] = postKind;
    data['Post_Status'] = postStatus;
    data['Pin_To_Top'] = pinToTop;
    data['Tag'] = tag;
    data['Source_Kind'] = sourceKind;
    data['Partner_ID'] = partnerId;
    data['UserName'] = userName;
    data['Rectangle_Image_URL'] = rectangleImageUrl;
    data['Rectangle_Image_FileName'] = rectangleImageFileName;
    data['Square_Image_URL'] = squareImageUrl;
    data['Square_Image_FileName'] = squareImageFileName;
    data['Video_FileName'] = videoFileName;
    data['Video_URL'] = videoUrl;
    data['Spin360_URL'] = spin360Url;
    data['Approved_DateTime'] = approvedDateTime;
    data['Visits_Count'] = visitsCount;
    data['Bidders_Count'] = biddersCount;
    data['Offers_Count'] = offersCount;
    data['Highest_Price'] = highestPrice;
    data['Car_ID'] = carId;
    data['Category_ID'] = categoryId;
    data['Category_Name_PL'] = categoryNamePl;
    data['Category_Name_SL'] = categoryNameSl;
    data['Make_ID'] = makeId;
    data['Make_Name_PL'] = makeNamePl;
    data['Make_Name_SL'] = makeNameSl;
    data['Class_ID'] = classId;
    data['Class_Name_PL'] = classNamePl;
    data['Class_Name_SL'] = classNameSl;
    data['Model_ID'] = modelId;
    data['Model_Name_PL'] = modelNamePl;
    data['Model_Name_SL'] = modelNameSl;
    data['Car_Name_PL'] = carNamePl;
    data['Car_Name_SL'] = carNameSl;
    data['Car_Name_With_Year_PL'] = carNameWithYearPl;
    data['Car_Name_With_Year_SL'] = carNameWithYearSl;
    data['Manufacture_Year'] = manufactureYear;
    data['Plate_Number'] = plateNumber;
    data['Chassis_Number'] = chassisNumber;
    data['Technical_Description_PL'] = technicalDescriptionPl;
    data['Technical_Description_SL'] = technicalDescriptionSl;
    data['Chassis_Number1'] = chassisNumber1;
    data['Plate_Number1'] = plateNumber1;
    data['Mileage'] = mileage;
    data['Warranty_isAvailable'] = warrantyIsAvailable;
    data['Color_Interior'] = colorInterior;
    data['Interior_Color_Name_PL'] = interiorColorNamePl;
    data['Interior_Color_Name_SL'] = interiorColorNameSl;
    data['Color_Exterior'] = colorExterior;
    data['Exterior_Color_Name_PL'] = exteriorColorNamePl;
    data['Exterior_Color_Name_SL'] = exteriorColorNameSl;
    data['isReady_For_Sale'] = isReadyForSale;
    data['Internal_Remarks'] = internalRemarks;
    data['Inspection_Report_isAvailable'] = inspectionReportIsAvailable;
    data['Inspection_Report_FileName'] = inspectionReportFileName;
    data['Inspection_Report_URL'] = inspectionReportUrl;
    data['Inspection_Report_Date'] = inspectionReportDate;
    data['Asking_Price'] = askingPrice;
    data['Minimum_Price'] = minimumPrice;
    data['Is_Bidding_Enabled'] = isBiddingEnabled;
    data['isSold'] = isSold;
    data['Inspection_Report_isBought'] = inspectionReportIsBought;
    data['isFavorite'] = isFavorite;
    return data;
  }
}
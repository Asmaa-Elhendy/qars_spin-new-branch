
import 'package:qarsspin/model/partner_rating.dart';

class RatingData{
  String name;
  num value;

  RatingData({required this.name,required this.value});
}
class PartnerRating{
  num total;
  List<RatingData> ratingData;
  PartnerRating({required this.total,required this.ratingData});
}


class Offer{

  // "Offer_ID": 90,
  // "Post_ID": 199,
  // "UserName": "QA97431097673",
  // "Offer_DateTime": "2025-07-12 23:19:23",
  // "Offer_Price": "21000.000",
  // "Offer_Origin": "Mobile App - iOS",
  // "Full_Name": "Abdullah nasr Mohammed",
  // "Avatar_FileName": null,
  // "Avatar_URL": null
  //

  int id;
  int postId;
  String userName;
  String dateTime;
  String price;
  String origin;
  String fullName;
  String? filename;
  String avatarUrl;

  Offer({required this.id,required this.price,required this.avatarUrl,required this.dateTime,this.filename,required this.fullName,required this.origin,required this.postId,required this.userName});
}
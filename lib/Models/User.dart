class User{
  String email;
  String name;
  String userId;
  String photoPath;
  String userType;
  String gender;
  String number;
  User({this.email,this.name,this.userId,this.userType,this.gender,this.number});
  
  User.fromMap(Map<String, dynamic> map) {
    this.userId=map["userId"];
    this.email = map["email"];
    this.name=map["name"];
    this.photoPath=map["photoPath"];
    this.userType=map["userType"];
    this.gender=map["gender"];
    this.number=map["number"];
  }
  
  toJson(String userId) {
    return {
      "userId":userId,
      "email": this.email,
      //"photoPath":this.photopath,
      "name": this.name,
      "userType":this.userType,
      "gender":this.gender,
      "number":this.number
      };}
}
class Assignment{
  String id;
  String title;
  String assignmentType;
  String subject;
  String docType;
  int noOFPages;
  String engLevel;
  String style;
  String deadline;
  String uploadDate;
  String description;
  String coAdmin;
  int tutorPayment;
  String additionalNotes;
  Assignment({this.id,this.title,this.assignmentType,this.subject,this.docType,this.noOFPages,this.engLevel,this.style,
  this.deadline,this.uploadDate,this.description,this.coAdmin,this.tutorPayment,this.additionalNotes});



  Assignment.fromMap(Map<String , dynamic> map){
    this.id=map["id"];
    this.title=map["title"];
    this.assignmentType=map["assignmentType"];
    this.subject=map["subject"];
    this.docType=map["docType"];
    this.noOFPages=map["noOfPages"];
    this.engLevel=map["engLevel"];
    this.style=map["style"];
    this.deadline=map["deadline"];
    this.uploadDate=map["uploadDate"];
    this.description=map["description"];
    this.coAdmin=map["coAdmin"];
    this.tutorPayment=map["tutorPayment"];
    this.additionalNotes=map["additionalNotes"];

  }

toJson(){
  return{
    "id":this.id,
    "title":this.title,
    "assignmentType":this.assignmentType,
    "subject":this.subject,
    "docType":this.docType,
    "noOfPages":this.noOFPages,
    "engLevel":this.engLevel,
    "style":this.style,
    "deadline":this.deadline,
    "uploadDate":this.uploadDate,
    "description":this.description,
    "coAdmin":this.coAdmin,
    "tutorPayment":this.tutorPayment,
    "additionalNotes":this.additionalNotes

  };
}

}
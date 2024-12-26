class CustomerModel{

  String? email;
  String?fullName;
  String? password;

  CustomerModel({
    this.email,
    this.fullName,
    this.password
  });

  Map<String,dynamic> toJson()
  {
    Map<String,dynamic> map ={};
    map.addAll({
      "email":email,
      'first_name':fullName,
      'password':password,
      'username':email
    });
    return map;
  }

}
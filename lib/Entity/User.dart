class User {
  String name;
  String mail;
  String mobile;
  Map<String, dynamic> contactData;

  User({
    this.name,
    this.mail,
    this.mobile,
    this.contactData,
  });

  fromJson(var jsonObj) {
    this.name = jsonObj['name'];
    this.mail = jsonObj['mail'];
    this.mobile = jsonObj['mobile'];
    return this;
  }
}

// class to contain the basic information for a user
// ex. first name, last name, uid

class BasicUserInfo {
  final String uid;
  final String firstName;
  final String lastName;

  // ctor that takes params uID, firstName, lastName
  // uid can be retrieved from authentication
  BasicUserInfo(this.uid, this.firstName, this.lastName);

  // converts json to a BasicUserInfo object
  // param is a Map<String, dynamic> (useful for firestore)
  BasicUserInfo.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        firstName = json['firstName'],
        lastName = json['lastName'];

  // converts from a BasicUserInfo object to json
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'firstName': firstName,
        'lastName': lastName,
      };


  @override 
  bool operator==(Object other) => 
  other is BasicUserInfo && uid == other.uid && firstName == other.firstName && lastName == other.lastName;

  @override 
  int get hashCode => super.hashCode;
}

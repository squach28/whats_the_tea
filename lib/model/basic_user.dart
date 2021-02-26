// class to contain the ESSENTIAL information for a user
// ex. first name, last name, uid

class BasicUserInfo {
  final String uid;
  final String firstName;
  final String lastName;

  // ctor that takes params uID, firstName, lastName
  // uID can be retrieved from authentication
  BasicUserInfo(this.uid, this.firstName, this.lastName);

  BasicUserInfo.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        firstName = json['firstName'],
        lastName = json['lastName'];

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'firstName': firstName,
        'lastName': lastName,
      };
}

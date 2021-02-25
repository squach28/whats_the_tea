import 'package:whats_the_tea/model/channel.dart';

class User {
  final String uID;
  final String firstName;
  final String lastName;
  final List<User> friends;
  final List<Channel> channels;

  // ctor that takes params uID, firstName, lastName
  // uID can be retrieved from authentication
  User(this.uID, this.firstName, this.lastName, this.friends, this.channels);

  User.fromJson(Map<String, dynamic> json)
      : uID = json['uID'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        friends = json['friends'],
        channels = json['channels'];

  Map<String, dynamic> toJson() => {
        'uID': uID,
        'firstName': firstName,
        'lastName': lastName,
        'friends': [],
        'channels': []
      };
}

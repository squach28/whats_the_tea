import 'package:whats_the_tea/model/basic_user.dart';
import 'package:whats_the_tea/model/channel.dart';

class User {
  final String uid;
  final String firstName;
  final String lastName;
  final List<User> friends;
  final List<Channel> channels;
  final List<BasicUserInfo> friendRequests;
  final List<BasicUserInfo> friendRequestsSent;
  // final String imageURL 

  // ctor that takes params uid, firstName, lastName
  // uid can be retrieved from authentication
  User(this.uid, this.firstName, this.lastName, this.friends, this.channels,
      this.friendRequests, this.friendRequestsSent);

  // converts from json to a User object
  User.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        friends = json['friends'],
        channels = json['channels'],
        friendRequests = json['friendRequests'],
        friendRequestsSent = json['friendRequestsSent'];
  
  // converts from a User object to json
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'firstName': firstName,
        'lastName': lastName,
        'friends': friends,
        'channels': channels,
        'friendRequests' : friendRequests,
        'friendRequestsSent': friendRequestsSent
      };
}

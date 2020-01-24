import 'package:cloud_firestore/cloud_firestore.dart';

//// Embedded Maps

// class Option {
//   String value;
//   String detail;
//   bool correct;

//   Option({this.correct, this.value, this.detail});
//   Option.fromMap(Map data) {
//     value = data['value'];
//     detail = data['detail'] ?? '';
//     correct = data['correct'];
//   }
// }

// class Question {
//   String text;
//   List<Option> options;
//   Question({this.options, this.text});

//   Question.fromMap(Map data) {
//     text = data['text'] ?? '';
//     options =
//         (data['options'] as List ?? []).map((v) => Option.fromMap(v)).toList();
//   }
// }

///// Database Collections

class Room {
  String roomId;
  String requestDocId;
  String requester;
  String requestCategory;
  String requesterDisplayName;
  String requesterPhotoUrl;
  String requestCompensation;
  String serviceProvider;
  String serviceProviderPhotoUrl;
  String serviceProviderDisplayName;
  String serviceProviderUid;
  

  Room({
    this.roomId,
    this.requestDocId,
    this.requester,
    this.requestCategory,
    this.requesterDisplayName,
    this.requesterPhotoUrl,
    this.requestCompensation,
    this.serviceProvider,
    this.serviceProviderPhotoUrl,
    this.serviceProviderDisplayName,
    this.serviceProviderUid
  });
}

class Request {
  String docId;
  String status;
  String id;
  String category;
  String location;
  String compensation;
  String description;
  String requesterUid;
  String requesterEmail;
  String requesterDisplayName;
  String requesterPhotoUrl;
  List serviceProviders;
  Timestamp lastUpdated;

  Request(
      {this.docId,
      this.status,
      this.id,
      this.category,
      this.location,
      this.compensation,
      this.description,
      this.requesterUid,
      this.requesterEmail,
      this.requesterDisplayName,
      this.requesterPhotoUrl,
      this.serviceProviders,
      this.lastUpdated});

  // factory Request.fromMap(Map data) {
  //   return Request(
  //     id: data['id'] ?? '',
  //     title: data['title'] ?? '',
  //     location: data['location'] ?? '',
  //     compensation: data['compensation'] ?? '',
  //     description: data['description'] ?? '',
  //     requesterUid: data['requesterUid'] ?? '',
  //     requesterDisplayName: data['requesterDisplayName'] ?? '',
  //     lastUpdated: data['lastUpdated']
  //   );
  // }

}

// class Quiz {
//   String id;
//   String title;
//   String description;
//   String video;
//   String topic;
//   List<Question> questions;

//   Quiz(
//       {this.title,
//       this.questions,
//       this.video,
//       this.description,
//       this.id,
//       this.topic});

//   factory Quiz.fromMap(Map data) {
//     return Quiz(
//         id: data['id'] ?? '',
//         title: data['title'] ?? '',
//         topic: data['topic'] ?? '',
//         description: data['description'] ?? '',
//         video: data['video'] ?? '',
//         questions: (data['questions'] as List ?? [])
//             .map((v) => Question.fromMap(v))
//             .toList());
//   }
// }

// class Topic {
//   final String id;
//   final String title;
//   final String description;
//   final String img;
//   final List<Quiz> quizzes;

//   Topic({this.id, this.title, this.description, this.img, this.quizzes});

//   factory Topic.fromMap(Map data) {
//     return Topic(
//       id: data['id'] ?? '',
//       title: data['title'] ?? '',
//       description: data['description'] ?? '',
//       img: data['img'] ?? 'default.png',
//       quizzes: (data['quizzes'] as List ?? [])
//           .map((v) => Quiz.fromMap(v))
//           .toList(), //data['quizzes'],
//     );
//   }
// }

class User {
  String uid;
  String email;
  bool emailVerified;
  String phoneNumber;
  String displayName;
  String photoUrl;
  DateTime lastActivity;

  User({this.uid, this.email,this.emailVerified,this.phoneNumber, this.displayName, this.photoUrl, this.lastActivity});

  factory User.fromMap(Map data) {
    return User(
        uid: data['uid'],
        email: data['email'] ?? '',
        emailVerified: data['emailVerified'],
        phoneNumber: data['phoneNumber'] ?? '',
        displayName: data['displayName'] ?? '',
        photoUrl: data['photoUrl'] ?? '',
        lastActivity: data['lastActivity']);
  }
}

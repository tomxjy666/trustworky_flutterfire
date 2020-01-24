import 'services.dart';
import 'package:firebase_analytics/firebase_analytics.dart';


/// Static global state. Immutable services that do not care about build context. 
class Global {
  // App Data
  static final String title = 'Fireship';

  // Services
  static final FirebaseAnalytics analytics = FirebaseAnalytics();

    // Data Models
  static final Map models = {
    // Topic: (data) => Topic.fromMap(data),
    // Quiz: (data) => Quiz.fromMap(data),
    User: (data) => User.fromMap(data),
    // Request: (data) => Request.fromMap(data)
  };

  // Firestore References for Writes
  // static final Collection<Topic> topicsRef = Collection<Topic>(path: 'topics');
  // static final Collection<Request> requestRef = Collection<Request>(path: 'requests');
  static final UserData<User> userRef = UserData<User>(collection: 'users'); 

  
}
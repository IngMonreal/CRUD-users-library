import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/response.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _Collection = _firestore.collection('users');

class UserService{
  static Future<Response> addUser({
    required String email,
    required String name,
    required String password,
  })async{
    Response response = Response();
    DocumentReference documentReference = _Collection.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "email":email,
      "name":name,
      "password":password,
    };

    var result = await documentReference.set(
      data
    ).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully added to the database";
    }).catchError((e){
      response.code = 500;
      response.message = e;
    });

    return response;
  }


  static Future<Response> logUser({
    required String email,
  }) async{
    Response response = Response();


    var result = await _Collection.where('email', isEqualTo: email).get().then(
          (value){
            if(value.size>0){
              response.code=200;
              response.message="User Found";
            } else {
              response.code=404;
              response.message="User nor Found";
            }
          },
          onError: (e){
            response.code = 500;
            response.message = e;
          }
    );

    return response;
  }
}
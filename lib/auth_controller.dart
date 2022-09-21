import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login/welcome_page.dart';
import 'package:login/login_page.dart';
import 'package:flutter/cupertino.dart';

class AuthController extends GetxController{
  //AuthController.instance...
  //auth controller can globally access in our app
  static AuthController instance=Get.find();

  //initialize the user,email,password,name...
  late Rx<User?>_user;

  //create the variable for firebase auth module
  //use auth can access a lot of properties from firebase
  FirebaseAuth auth=FirebaseAuth.instance;

  @override
  void onReady(){
    super.onReady();

    _user=Rx<User?>(auth.currentUser);

    //login/logup, the user will be notified
    _user.bindStream(auth.userChanges());

    //ever() == listen listen the _user.bindstream work
    ever(_user,_initialScreen);
  }
  
  _initialScreen(User? user){
    if(user==null){
      print("login page");
      Get.offAll(()=>LoginPage());
    }else{
      Get.offAll(()=>WelcomePage(email:user.email!));
    }
  }

  void register(String email,password) async {
    try{
      await auth.createUserWithEmailAndPassword(email: email, password: password);

    }catch(e){
      Get.snackbar(
        "About User",
        "User message",
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
        titleText:Text(
          "Account creation failed",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        messageText: Text(
          e.toString(),
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }

  }

  void login(String email,password) async {
    try{
      await auth.signInWithEmailAndPassword(email: email, password: password);

    }catch(e){
      Get.snackbar(
        "About Login",
        "Login message",
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText:Text(
          "Login failed",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        messageText: Text(
          e.toString(),
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }

  }

  void logOut() async {
    await auth.signOut();
  }
}
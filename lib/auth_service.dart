import "package:firebase_auth/firebase_auth.dart";
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login/login_page.dart';

class AuthService{
  // 1.handleAuthState()
  handleAuthState(){
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context,snapshot){
        if(snapshot.hasData){
          return HomePage();
        }
        else{
          return LoginPage();
        }
      },
    );
  }

  // 2.signInWithGoogle()
  // call from button press of UI
  signInWithGoogle() async {
    // try to get email id or gmail account from device
    final GoogleSignInAccount? googleUser=await GoogleSignIn(
      scopes: <String>['email']).signIn();

    // if found account or id, send it to google server and wait for authentication
    final GoogleSignInAuthentication googleAuth= await googleUser!.authentication;

    // base on authentication get, create a credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    //have credential and pass over firebase
    //firebase will return an instance base on credential which use later to show our information
    //like name, gmail account
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // 3.signOut()
  signOut(){
    FirebaseAuth.instance.signOut();
  }
}
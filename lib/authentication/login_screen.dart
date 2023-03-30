import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user_fyp/authentication/sheep.dart';
import 'package:user_fyp/authentication/signup_screen.dart';
import 'package:user_fyp/splashScreen/splash_screen.dart';
import '../OTP/generate_OTP.dart';
import '../global/global.dart';
import '../widgets/progress_dialog.dart';


class LoginScreen extends StatefulWidget
{
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}




class _LoginScreenState extends State<LoginScreen>
{

  loginUserNow() async
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c)
        {
          return ProgressDialogue(message: "Processing, please Wait",);
        }
    );
    final User? firebaseUser = (

        await fAuth.signInWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim(),
        ).catchError((msg){
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Error: " + msg.toString());
        })
    ).user;

    // for realtime database
     if(firebaseUser!= null)
    {
      DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("users");
      driversRef.child(firebaseUser.uid).once().then((driverkey)
      {
        final snap = driverkey.snapshot;
        if(snap.value != null)
        {
          currentFirebaseUser = firebaseUser;
          Fluttertoast.showToast(msg: "login Successful.");
          Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
        }
        else
        {
          Fluttertoast.showToast(msg: "no record exist with this detail");
          fAuth.signOut();
          Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));

        }

      });

    currentFirebaseUser = firebaseUser;
      Fluttertoast.showToast(msg: "login Successful.");
      Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
    }
    else
    {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error Occured During login");
    }
  }


  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validationForm()
  {

    if (!emailTextEditingController.text.contains("@"))
    {
      Fluttertoast.showToast(msg: "Email address is not valid. ");
    }
    else if (passwordTextEditingController.text.isEmpty)
    {
      Fluttertoast.showToast(msg: "Password is required. ");
    }
    else
    {
      loginUserNow();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset("assets/images/logo1.jpg"),
            ),
            const SizedBox(height: 10,),
            const Text(

              "Login as User",
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold
              ),
            ),


            TextField(
              controller: emailTextEditingController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "Email",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                hintStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),

              ),


            ),
            TextField(
              controller: passwordTextEditingController,
              keyboardType: TextInputType.text,
              obscureText: true,
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: "Password",
                hintText: "Password",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                hintStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),

              ),


            ),

            const SizedBox(height: 20,),

            ElevatedButton(
              onPressed: ()
              {
                //Navigator.push(context, MaterialPageRoute(builder: (c)=> DoctorDetailPage()));
                validationForm();

              },
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
              ),
              child: const Text(
                "Login",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18


                ),
              ),
            ),
            TextButton(
                child: Text(
                    "Already have an Account? Login Here"
                ),
              onPressed: ()
              {
                // Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginOTPPage()));
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupScreen()));
              },
            ),

          ],
        ),

      ),
    );
  }
}

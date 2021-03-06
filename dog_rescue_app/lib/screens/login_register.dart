import 'package:dog_rescue_app/controllers/google_signin_controller.dart';
import 'package:dog_rescue_app/controllers/login_controller.dart';
import 'package:dog_rescue_app/screens/home.dart';
import 'package:dog_rescue_app/screens/registration_screen.dart';
import 'package:dog_rescue_app/screens/reset_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({required Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //form key
  final _formkey = GlobalKey<FormState>();

  //editing controller
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //firebase

  final _auth = FirebaseAuth.instance;

  // var nameController;

  @override
  Widget build(BuildContext context) {
    //email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Enter your Email.";
        }
        //reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return "Please enter a valid email.";
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.mail),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    //password field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      // ignore: body_might_complete_normally_nullable
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return "Please Enter your password";
        }
        if (!regex.hasMatch(value)) {
          return "Please enter valid password of minimum 6 characters";
        }
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key_outlined),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Colors.teal,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                        child: SpinKitFadingGrid(
                      size: 50,
                      color: Colors.teal,
                    )));
            signIn(emailController.text, passwordController.text);
          },
          child: Text(
            "Login",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: ListView(
        children: [
          Container(
            width: 400,
            height: 800,
            color: Colors.grey[200],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/logo.jpg',
                    height: 200,
                    width: 200,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          emailField,
                          SizedBox(
                            height: 30,
                          ),
                          passwordField,
                          SizedBox(
                            height: 30,
                          ),
                          loginButton,
                        ],
                      )),
                ),
                Container(
                  child: TextButton(
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(color: Colors.teal),
                      ),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResetPassword()))),
                ),
                // loginUI(),
                Container(
                  child: Text("or"),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "Don't have an account?",
                        style: GoogleFonts.montserrat(color: Colors.black)),
                    TextSpan(
                        text: 'Sign up',
                        style: GoogleFonts.montserrat(color: Colors.teal),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => RegistrationScreen()));
                          })
                  ])),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  loginUI() {
    return Consumer<LoginController>(builder: (context, model, child) {
      //if already logged in
      if (model.userDetails != null) {
        return Center(
          child: loggedInUI(model),
        );
      } else {
        return loginControllers(context);
      }
    });
  }

  //login function
  void signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
                Fluttertoast.showToast(msg: "Login Successful"),
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomeScreen())),
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  loggedInUI(LoginController model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundImage:
              Image.network(model.userDetails!.photoURL ?? '').image,
          radius: 50,
        ),
        Text(model.userDetails!.displayName ?? ""),
        Text(model.userDetails!.email ?? ""),
        ActionChip(
            avatar: Icon(Icons.logout),
            label: Text("Logout"),
            onPressed: () {
              Provider.of<LoginController>(context, listen: false).logout();
            })
      ],
    );
  }

  loginControllers(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child: Image.asset("assets/images/google.png", width: 250),
          onTap: () {
            Provider.of<LoginController>(context, listen: false).googleLogin();
            //     .whenComplete(() {
            //   Navigator.of(context).pushReplacement(
            //       MaterialPageRoute(builder: (context) => HomeScreen()));
            // }
            //);
          },
        ),
      ],
    );

    // ;
  }
}

// Container(
//       height: 90,
//       width: 300,
//       padding: EdgeInsets.all(10),
//       child: Builder(
//         builder: (BuildContext newContext) {
//           return ElevatedButton(
//             child: Container(
//               margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
//               child: Row(
//                 children: [
//                   Image.asset(
//                     "assets/images/google_logo.png",
//                     height: 28,
//                     width: 40,
//                     alignment: Alignment(0.09, 0.5),
//                   ),
//                   Text('Sign in with Google',
//                       style: GoogleFonts.montserrat(
//                         fontStyle: FontStyle.normal,
//                         fontSize: 20,
//                         color: Colors.black,
//                       )),
//                 ],
//               ),
//             ),
//             style: ElevatedButton.styleFrom(
//               primary: Colors.white,
//               //backgroundColor: Colors.white,
//               onSurface: Colors.white,
//               shape: (RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                   side: BorderSide(color: Colors.white))),
//             ),
//             onPressed: () {
//               Provider.of<GoogleSignInController>(context, listen: false)
//                   .login();
//             },
//           );
//         },
//       ),
//     );
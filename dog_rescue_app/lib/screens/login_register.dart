import 'package:dog_rescue_app/screens/home.dart';
//import 'package:dog_rescue_app/screens/option_screen.dart';
import 'package:dog_rescue_app/provider/google_sign_in.dart';
import 'package:dog_rescue_app/screens/registration_screen.dart';
import 'package:dog_rescue_app/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(new MaterialApp(
//     debugShowCheckedModeBanner: false,
//     title: 'splash',
//     theme: ThemeData(
//       textTheme: GoogleFonts.montserratTextTheme(),
//     ),
//     home: new LoginScreen(),
//   ));
// }

class LoginScreen extends StatefulWidget {
  const LoginScreen({required Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //form key
  final _formkey = GlobalKey<FormState>();
  //editing controller
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //firebase

  final _auth = FirebaseAuth.instanceFor;

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
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {},
          child: Text(
            "Login",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
    return Scaffold(
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
                  child: Image.asset('assets/images/logo.jpg'),
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
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(color: Colors.teal),
                  ),
                ),
                Container(
                  child: Text("or"),
                ),
                Container(
                  height: 90,
                  width: 300,
                  padding: EdgeInsets.all(10),
                  child: Builder(
                    builder: (BuildContext newContext) {
                      return ElevatedButton(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/images/google_logo.png",
                                height: 28,
                                width: 40,
                                alignment: Alignment(0.09, 0.5),
                              ),
                              Text('Sign in with Google',
                                  style: GoogleFonts.montserrat(
                                    fontStyle: FontStyle.normal,
                                    fontSize: 20,
                                    color: Colors.black,
                                  )),
                            ],
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          //backgroundColor: Colors.white,
                          onSurface: Colors.white,
                          shape: (RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: Colors.white))),
                        ),
                        onPressed: () {
                          final provider = Provider.of<GoogleSignInProvider>(
                              context,
                              listen: false);
                          provider.googleLogin();
                        },
                      );
                    },
                  ),
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
}
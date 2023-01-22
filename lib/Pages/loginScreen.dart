import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          title: const Text('Sign in'),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(children: [
              SizedBox(
                height: 20,
              ),
              const MyStatefulWidget(),
            ]),
          ),
        ));
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String errorMessageMail = "";
  String errorMessagePsw = "";

  Future<void> _manageSignIn(BuildContext context, String provider) async {
    switch(provider){
      case "Google":
        final gooleSignIn = GoogleSignIn();
        final googleSignInAccount = await gooleSignIn.signIn();
        if (googleSignInAccount != null) {
          final googleAuth = await googleSignInAccount.authentication;
          if (googleAuth.accessToken != null && googleAuth.idToken != null) {
            try {
              await auth.signInWithCredential(GoogleAuthProvider.credential(
                  idToken: googleAuth.idToken, accessToken: googleAuth.accessToken));
              print("successfully login!");
            } on FirebaseAuthException catch (e) {
              setState(() {
                errorMessageMail = e.message!;
              });
            }
            catch (e) {
              setState(() {
                errorMessageMail = "Something went wrong";
              });
              print(e.toString());
            }
          }
        }
        break;
      case "Facebook":
        final facebookLogin = FacebookAuth.instance.login();
      try {
        final result = await facebookLogin;
        if (result.accessToken != null) {
          final facebookAuthCredential = FacebookAuthProvider.credential(result.accessToken!.token);
          await auth.signInWithCredential(facebookAuthCredential);
          print("successfully login!");
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          errorMessageMail = e.message!;
        });
      }
      catch (e) {
        setState(() {
          errorMessageMail = "Something went wrong";
        });
        print(e.toString());
      }

        break;
      case "Apple":
      //TODO: Implement Apple Sign in
        break;
      case "Email":
        try {
          final credentials = await auth.signInWithEmailAndPassword(
              email: email.text, password: password.text);

        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            setState(() {
              errorMessageMail = "No user found for that email.";
            });
          } else if (e.code == 'wrong-password') {
            setState(() {
              errorMessageMail = "Wrong password provided for that user.";
            });
          }
        } catch (e) {
          print(e.toString());
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Divider(),
            TextFormField(
              controller: email,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
              onEditingComplete: () {
                if (email.text == null || email.text.isEmpty) {
                  setState((){
                    errorMessageMail = "Please enter your email";
                  });
                } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email.text)) {
                  setState(() {
                    errorMessageMail = "Please enter a valid email";
                  });
                } else {
                  setState(() {
                    errorMessageMail = "";
                  }
                  );
                }
                return null;
              },
            ),
            Divider(),
            TextFormField(
              controller: password,
              obscureText: true,
              autocorrect: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
              onEditingComplete: () {
                if (password.text == null || password.text.isEmpty) {
                  setState(() {
                    errorMessagePsw = "Please enter your password.";
                  });
                } else {
                  setState(() {
                  errorMessagePsw = "";
                });
                }
              },
            ),
            Divider(),
            Text(errorMessageMail+'\n'+errorMessagePsw, textAlign: TextAlign.left, style: TextStyle(color: Colors.red),),

            Divider(),
            Divider(),
            SignInButtonBuilder(
              text: 'Sign in with Email',
              icon: Icons.email,
              onPressed: () {
                _manageSignIn(context, "Email");
              },
              backgroundColor: Colors.blueGrey[700]!,
              width: 220.0,
            ),
            Divider(),
            Divider(),
            Divider(),
            SignInButton(
              Buttons.Google,
              onPressed: () {
                _manageSignIn(context, "Google");
              },
            ),
            Divider(),
            SignInButton(
              Buttons.FacebookNew,
              onPressed: () {
                _manageSignIn(context, "Facebook");
              },
            ),
            Divider(),
            SignInButton(
              Buttons.AppleDark,
              onPressed: () {
                _manageSignIn(context, "Apple");
              },
            ),
         ],

          /*
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: email,
                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: password,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Enter your password',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the password';
                  }
                  return null;
                },
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: SignInButtonBuilder(
                  text: 'Sign in with Email',
                  // height: ,
                  width: MediaQuery.of(context).size.width-50,
                  icon: Icons.email,
                  onPressed: () async {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (_formKey.currentState!.validate()) {
                      signInWithMailAndPassword(email.text, password.text, () {Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));});
                    }
                  },
                  backgroundColor: Colors.blueGrey[700]!,
                ),
              ),
            ),
            Center(
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: SignInButton(
                    // make the button bigger
                    Buttons.Google,
                    text: "Sign in with Google",
                    onPressed: () {
                      googleSignIn(context);
                    },
                  )),
            ),
          ],
          */
        ),
      ),
    );
  }
}
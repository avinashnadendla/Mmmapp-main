import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:mmmapp/Screens/Authenticate/signup_form.dart';
import 'package:mmmapp/bloc/AuthenticationBloc/registerbloc.dart';
import 'package:mmmapp/bloc/userRepository.dart';

class RegisterScreen extends StatelessWidget {
  final UserRepository _userRepository;

  const RegisterScreen({Key key, UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Color(0xff6a515e),
        ),
      ),
      body: bloc.BlocProvider<RegisterBloc>(
        create: (context) => RegisterBloc(userRepository: _userRepository),
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xfff2cbd0), Color(0xfff4ced9)],
            ),
          ),
          child: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
     Container(
                    padding: const EdgeInsets.only(top: 100, left: 50),
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.white, Colors.white.withOpacity(0.4)],
                      ),
                    ),
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 40,
                        color: Color(0xff6a515e),
                      ),
                    ),
                  ),
              
                Container(
                  margin: const EdgeInsets.only(top: 230),
                  child: RegisterForm(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

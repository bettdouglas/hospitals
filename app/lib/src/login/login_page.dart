import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hospitals_riverpod/src/login/login_provider.dart';
import 'package:hospitals_riverpod/src/sign_up/sign_up_page.dart';

class LoginPage extends ConsumerWidget {
  LoginPage({Key? key}) : super(key: key);

  static String get route => '/sign-in';

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width / 10,
          vertical: width / 10,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Email'),
              SizedBox(),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                ),
                controller: _emailController,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: width / 20),
              Text('Password'),
              SizedBox(),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                ),
                controller: _passwordController,
                textInputAction: TextInputAction.done,
              ),
              SizedBox(height: width / 20),
              Consumer(
                builder: (context, ref, child) {
                  return ElevatedButton(
                    onPressed: () async {
                      ref.read(loginProvider.notifier).login(
                          _emailController.text, _passwordController.text);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: width / 20,
                      child: Text('Log in'),
                    ),
                  );
                },
              ),
              SizedBox(height: width / 15),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      context.push(SignUpPage.route);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: width / 20,
                      child: Text('Sign Up'),
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      // context.push(ForgotPasswordPage.route);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: width / 20,
                      child: Text('Forgot Password?'),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

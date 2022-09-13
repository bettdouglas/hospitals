import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:hospitals_riverpod/src/sign_up/sign_up_provider.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({Key? key}) : super(key: key);
  static String get route => '/sign-up';

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameKey = 'name';
  final _passwordKey = 'password';
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width / 5,
          vertical: width / 10,
        ),
        child: SingleChildScrollView(
          child: FormBuilder(
            key: formKey,
            child: Stack(
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    return ref.read(signUpProvider).maybeWhen(
                          orElse: () => SizedBox(),
                          loading: (msg) => Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Email'),
                    SizedBox(),
                    FormBuilderTextField(
                      name: _nameKey,
                      decoration: InputDecoration(
                        hintText: 'Enter an email',
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: 'An email is required',
                        ),
                        FormBuilderValidators.email(),
                      ]),
                      autovalidateMode: AutovalidateMode.always,
                      controller: _emailController,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: width / 20),
                    Text('Password'),
                    SizedBox(),
                    FormBuilderTextField(
                      name: _passwordKey,
                      decoration: InputDecoration(
                        hintText: 'Enter a password',
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(
                          6,
                          errorText: 'Please enter a longer password',
                        ),
                      ]),
                      controller: _passwordController,
                      textInputAction: TextInputAction.done,
                    ),
                    SizedBox(height: width / 20),
                    Consumer(
                      builder: (context, ref, child) {
                        return ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState?.saveAndValidate() ??
                                false) {
                              final values = formKey.currentState!.value;
                              ref.read(signUpProvider.notifier).signUp(
                                  values[_nameKey], values[_passwordKey]);
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: width / 20,
                            child: Text('Sign Up'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

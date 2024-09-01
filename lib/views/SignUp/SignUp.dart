import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hiring_task/provider/AuthManager.dart';
import 'package:hiring_task/router/RouteConstants.dart';
import 'package:hiring_task/utils/AppColors.dart';
import 'package:hiring_task/utils/AppDimens.dart';
import 'package:hiring_task/utils/Validatioms.dart';
import 'package:hiring_task/widgets/CustomTextFormField.dart';
import 'package:hiring_task/widgets/RoundedButton.dart';
import 'package:hiring_task/widgets/Snackbar.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late AuthManager auth;

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode repeatPasswordFocusNode = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isObsecure = true;
  bool rememberMe = true;

  Logger logger = Logger();

  Widget passwordField() {
    return CustomTextFormField(
      controller: _passwordController,
      obscure: isObsecure,
      icon: isObsecure
          ? const Icon(Icons.visibility_outlined, size: 18)
          : const Icon(Icons.visibility_off_outlined, size: 18),
      iconPressed: () => setState(() {
        isObsecure = !isObsecure;
      }),
      focusNode: passwordFocusNode,
      validator: (p) => validatePassword(p),
    );
  }

  Widget repeatPasswordField() {
    return CustomTextFormField(
      obscure: isObsecure,
      icon: isObsecure
          ? const Icon(Icons.visibility_outlined, size: 18)
          : const Icon(Icons.visibility_off_outlined, size: 18),
      iconPressed: () => setState(() {
        isObsecure = !isObsecure;
      }),
      controller: _repeatPasswordController,
      focusNode: repeatPasswordFocusNode,
      validator: (p) => validatePassword(p),
    );
  }

  Widget mainContent() {
    return Padding(
      padding: AppDimens.horizontalPadding20,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppDimens.sizebox65,
              Center(
                child: Text(
                  'Sign Up',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 24.w, color: AppColors.textPrimary),
                ),
              ),
              AppDimens.sizebox55,
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Hello there 👋', style: TextStyle(fontSize: 16.w, fontWeight: FontWeight.bold)),
              ),
              AppDimens.sizebox10,
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Please enter your username/email and password to sign Up.',
                  style: TextStyle(fontSize: 13.w, fontWeight: FontWeight.w300),
                ),
              ),
              AppDimens.sizebox35,
              Text('Username / Email', style: TextStyle(fontSize: 13.w)),
              CustomTextFormField(
                controller: _emailController,
                focusNode: emailFocusNode,
                validator: (e) => validateEmail(e),
              ),
              AppDimens.sizebox25,
              Text('Password', style: TextStyle(fontSize: 13.w)),
              passwordField(),
              AppDimens.sizebox25,
              Text('Repeat Password', style: TextStyle(fontSize: 13.w)),
              repeatPasswordField(),
              AppDimens.sizebox15,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 35,
                    child: CheckboxListTile(
                      checkColor: AppColors.background,
                      activeColor: Colors.black,
                      enableFeedback: false,
                      checkboxShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      value: rememberMe,
                      onChanged: (value) => setState(() {
                        rememberMe = value ?? false;
                      }),
                    ),
                  ),
                  const Text(
                    'Remember me',
                    style: TextStyle(fontSize: 12, color: AppColors.textPrimary),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {},
                    child: const Center(
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(fontSize: 12, color: AppColors.textPrimary),
                      ),
                    ),
                  ),
                ],
              ),
              AppDimens.sizebox15,
              RoundedButton(text: 'Sign Up', press: () => signUpWithEmailAndPassword()),
              AppDimens.sizebox15,
              Center(
                child: GestureDetector(
                  onTap: () => signIn(),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: AppColors.textPrimary,
                        fontStyle: FontStyle.italic,
                      ),
                      text: 'Already Have an account?',
                      children: [
                        TextSpan(
                          text: ' Sign in',
                          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    auth = context.read<AuthManager>();
    return Scaffold(
      body: SafeArea(
        child: mainContent(),
      ),
    );
  }

  signUpWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text.trim() == _repeatPasswordController.text.trim()) {
        auth.signUpWithEmailAndPassword(_emailController.text, _passwordController.text, context);
      } else {
        showSnacBar(context, content: 'The passwords must match');
      }
    }
  }

  signIn() => context.go(RouteConstants.loginPath);
}

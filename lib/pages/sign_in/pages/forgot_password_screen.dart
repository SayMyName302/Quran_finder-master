import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:squip/src/common/widgets/app_text_field.dart';
import 'package:squip/src/pages/login/providers/login_provider.dart';
import '../../../common/widgets/app_title.dart';
import '../../../common/widgets/branding_button.dart';
import '../widgets/subtitle_row.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  var email = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AppTitle(),
              SizedBox(height: 80.h,),
              Image.asset("assets/images/icons/forgot.png",height: 70.h,width: 70.w,),
              const SubTitleRow(title: "Forgot Your Password"),
              _buildForm(),
            ],
          ),
        ),
      ),
    );
  }

  _buildForm() {
    return Container(
      margin: EdgeInsets.only(left: 20.w,right: 20.w,top: 50.h),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            AppTextField(hint: "Type Your Email", controller: email, icon: Icons.email),
            SizedBox(height: 50.h,),
            BrandingButton(title: "Send", onTap: (){
              if(formKey.currentState!.validate()){
                Provider.of<LoginProvider>(context,listen: false).resetPassword(email: email.text, context: context);
              }
            },alignment: Alignment.center,),
          ],
        ),
      ),
    );
  }
}

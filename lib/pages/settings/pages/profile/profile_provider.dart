import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:nour_al_quran/pages/settings/pages/profile/user_profile.dart';
import 'package:nour_al_quran/shared/localization/languages.dart';
import 'package:nour_al_quran/shared/routes/routes_helper.dart';
import 'package:nour_al_quran/shared/utills/app_constants.dart';
import 'package:nour_al_quran/shared/widgets/easy_loading.dart';
import 'package:provider/provider.dart';

import '../../../bottom_tabs/provider/bottom_tabs_page_provider.dart';

class ProfileProvider extends ChangeNotifier{
  UserProfile? _userProfile = Hive.box(appBoxKey).get(userProfileKey);
  UserProfile? get userProfile => _userProfile;
  Languages _languages = Languages.languages[0];
  Languages get languages => _languages;
  String _fromWhere = "";
  String get fromWhere => _fromWhere;



  setFromWhere(String fromWhere){
    _fromWhere = fromWhere;
    notifyListeners();
  }

  void updatePreferredLanguage(Languages languages){
    _languages = languages;
    _userProfile!.setPreferredLanguage = languages.languageCode;
    saveUserProfile(_userProfile!);
  }

  updateProfile(String name,String email,String password){
    if(_userProfile!.fullName != name || _userProfile!.email != email || _userProfile!.password != password){
      _userProfile!.setFullName = name;
      _userProfile!.setEmail = email;
      _userProfile!.setPassword = password;
      saveUserProfile(_userProfile!);
      EasyLoadingDialog.show(context: RouteHelper.currentContext,radius: 20.r);
      try{
        if(_userProfile!.email != email){
          FirebaseAuth.instance.currentUser!.updateEmail(email);
        }else if(_userProfile!.password != password){
          FirebaseAuth.instance.currentUser!.updatePassword(password);
        }
      }on FirebaseAuthException catch(e){
        Fluttertoast.showToast(msg: e.message.toString());
      }
      FirebaseFirestore.instance.collection('users').doc(_userProfile!.uid).update({
        "email":email,
        "fullName":name,
        "password":password
      }).then((value) {
        EasyLoadingDialog.dismiss(RouteHelper.currentContext,);
        Navigator.of(RouteHelper.currentContext).pop();
      });
    }else{
      ScaffoldMessenger.of(RouteHelper.currentContext).showSnackBar(const SnackBar(content: Text('Nothing to Update')));
    }
  }
  saveUserProfile(UserProfile userProfile){
    _userProfile = userProfile;
    /// it is used for language changing from profile
    _languages = Languages.languages[Languages.languages.indexWhere((element) => element.languageCode == _userProfile!.preferredLanguage)];
    notifyListeners();
    Hive.box(appBoxKey).put(loginStatusString, 1);
    Hive.box(appBoxKey).put(userProfileKey, userProfile);
  }

  updateUserProfile(){
    Hive.box(appBoxKey).put(userProfileKey, userProfile);
  }

  void uploadDataToFireStore(String uid,UserProfile userProfile,) async{
    await FirebaseFirestore.instance.collection('users').doc(uid).set(userProfile.toJson()).then((value){
      EasyLoadingDialog.dismiss(RouteHelper.currentContext);
      saveUserProfile(userProfile);
      Provider.of<BottomTabsPageProvider>(RouteHelper.currentContext,listen: false).setCurrentPage(0);
      /// save on boarding done and redirect user to application
      Hive.box(appBoxKey).put(onBoardingDoneKey, "done");
      Navigator.of(RouteHelper.currentContext).pushNamedAndRemoveUntil(RouteHelper.application, (route) => false);
      // if(_fromWhere == "home"){
      //
      // }else if(_fromWhere == "fromInApp"){
      //   Navigator.of(RouteHelper.currentContext).pop("login");
      // }
    });
  }

  resetUserProfile(){
    _userProfile = null;
    notifyListeners();
    Hive.box(appBoxKey).delete(userProfileKey);
    Hive.box(appBoxKey).put(loginStatusString, 0);
  }
}
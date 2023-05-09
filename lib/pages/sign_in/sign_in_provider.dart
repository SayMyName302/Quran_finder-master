import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import '../onboarding/on_boarding.dart';
import '../settings/pages/profile/user_profile.dart';
import '../../shared/routes/routes_helper.dart';
import '../../shared/utills/app_constants.dart';
import '../../shared/widgets/easy_loading.dart';
import 'package:provider/provider.dart';

import '../settings/pages/profile/profile_provider.dart';

class SignInProvider extends ChangeNotifier {
  signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(scopes: <String>['email']).signIn();
      if (googleUser != null) {
        /// to show loading when user select any google account after clicking on google button
        Future.delayed(
            Duration.zero,
            () => EasyLoadingDialog.show(
                context: RouteHelper.currentContext, radius: 20.r));

        /// google sign in code
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);

        /// firebase sign in with google account
        try {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((userCredential) async {
            /// to check weather user exist in the existing list of fire store database
            var doc =
                await FirebaseFirestore.instance.collection("users").get();
            List<UserProfile> usersList =
                doc.docs.map((e) => UserProfile.fromJson(e.data())).toList();

            /// if list is not empty means there are some users logged in to this app
            if (usersList.isNotEmpty) {
              /// now check whether this user uid is available in the list or not
              int userIndex = usersList.indexWhere(
                  (element) => element.uid == userCredential.user!.uid);
              if (userIndex != -1) {
                Future.delayed(Duration.zero, () {
                  /// this could be from edit profile page or from home screen user icon available at the top right corner
                  Provider.of<ProfileProvider>(RouteHelper.currentContext,
                          listen: false)
                      .saveUserProfile(usersList[userIndex]);
                  String fromWhere = Provider.of<ProfileProvider>(
                          RouteHelper.currentContext,
                          listen: false)
                      .fromWhere;
                  if (fromWhere == "home") {
                    Navigator.of(RouteHelper.currentContext)
                        .pushNamedAndRemoveUntil(
                            RouteHelper.application, (route) => false);
                  } else {
                    /// this is from in App Purchase Bottom Sheet
                    Fluttertoast.showToast(msg: "called");
                    EasyLoadingDialog.dismiss(RouteHelper.currentContext);
                    Navigator.of(RouteHelper.currentContext).pop("login");
                  }
                });
              } else {
                /// if user id Does not exist so create new user then and save data to fire store db
                UserProfile userProfile = await setUserProfile(
                  userCredential: userCredential,
                  loginType: "google",
                );
                Future.delayed(
                    Duration.zero,
                    () => RouteHelper.currentContext
                        .read<ProfileProvider>()
                        .uploadDataToFireStore(
                            userCredential.user!.uid, userProfile));
              }
            } else {
              /// else list is empty and it is the first use who logged in to this app
              UserProfile userProfile = await setUserProfile(
                userCredential: userCredential,
                loginType: "google",
              );
              Future.delayed(
                  Duration.zero,
                  () => RouteHelper.currentContext
                      .read<ProfileProvider>()
                      .uploadDataToFireStore(
                          userCredential.user!.uid, userProfile));
            }
          });
        } on FirebaseAuthException catch (e) {
          Future.delayed(Duration.zero,
              () => EasyLoadingDialog.dismiss(RouteHelper.currentContext));
          showErrorSnackBar(e.message.toString());
        } catch (e) {
          Future.delayed(Duration.zero,
              () => EasyLoadingDialog.dismiss(RouteHelper.currentContext));
          showErrorSnackBar(e.toString());
        }
      }
    } on PlatformException {
      showErrorSnackBar("Network Error");
    } catch (e) {
      showErrorSnackBar("error");
    }
  }

  signInWithFaceBook() async {
    try {
      /// login in with facebook
      LoginResult facebookAuth = await FacebookAuth.instance
          .login(permissions: ["email", "public_profile", "user_friends"]);
      if (facebookAuth.accessToken != null) {
        /// to get user profile information
        var data = await FacebookAuth.instance.getUserData();
        final OAuthCredential authCredential =
            FacebookAuthProvider.credential(facebookAuth.accessToken!.token);
        try {
          /// sign in with facebook account using firebase auth
          await FirebaseAuth.instance
              .signInWithCredential(authCredential)
              .then((userCredential) async {
            /// to check weather user exist in the existing list of fire store database
            var doc =
                await FirebaseFirestore.instance.collection("users").get();
            List<UserProfile> usersList =
                doc.docs.map((e) => UserProfile.fromJson(e.data())).toList();

            /// if list is not empty means there are some users logged in to this app
            if (usersList.isNotEmpty) {
              int userIndex = usersList.indexWhere(
                  (element) => element.uid == userCredential.user!.uid);
              if (userIndex != -1) {
                Future.delayed(Duration.zero, () {
                  /// this could be from edit profile page or from home screen user icon available at the top right corner
                  Provider.of<ProfileProvider>(RouteHelper.currentContext,
                          listen: false)
                      .saveUserProfile(usersList[userIndex]);
                  String fromWhere = Provider.of<ProfileProvider>(
                          RouteHelper.currentContext,
                          listen: false)
                      .fromWhere;
                  if (fromWhere == "home") {
                    Navigator.of(RouteHelper.currentContext)
                        .pushNamedAndRemoveUntil(
                            RouteHelper.application, (route) => false);
                  } else {
                    /// this is from in App Purchase Bottom Sheet
                    Fluttertoast.showToast(msg: "called");
                    EasyLoadingDialog.dismiss(RouteHelper.currentContext);
                    Navigator.of(RouteHelper.currentContext).pop("login");
                  }
                });
              } else {
                UserProfile userProfile = await setUserProfile(
                    userCredential: userCredential,
                    loginType: "facebook",
                    image: data["picture"]['data']['url']);
                Future.delayed(
                    Duration.zero,
                    () => RouteHelper.currentContext
                        .read<ProfileProvider>()
                        .uploadDataToFireStore(
                            userCredential.user!.uid, userProfile));
              }
            } else {
              UserProfile userProfile = await setUserProfile(
                  userCredential: userCredential,
                  loginType: "facebook",
                  image: data["picture"]['data']['url']);
              Future.delayed(
                  Duration.zero,
                  () => RouteHelper.currentContext
                      .read<ProfileProvider>()
                      .uploadDataToFireStore(
                          userCredential.user!.uid, userProfile));
            }
          });
        } on FirebaseAuthException catch (e) {
          Future.delayed(Duration.zero,
              () => EasyLoadingDialog.dismiss(RouteHelper.currentContext));
          showErrorSnackBar(e.message.toString());
        } catch (e) {
          showErrorSnackBar("error");
          Future.delayed(Duration.zero,
              () => EasyLoadingDialog.dismiss(RouteHelper.currentContext));
        }
      }
    } on PlatformException {
      showErrorSnackBar("Network Error");
    }
  }

  signInWithEmailPassword(String email, String password) async {
    try {
      Future.delayed(
          Duration.zero,
          () => EasyLoadingDialog.show(
              context: RouteHelper.currentContext, radius: 20.r));
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((userCredential) async {
        /// to check weather user exist in the existing list of fire store database
        var doc = await FirebaseFirestore.instance.collection("users").get();
        List<UserProfile> usersList =
            doc.docs.map((e) => UserProfile.fromJson(e.data())).toList();
        if (usersList.isNotEmpty) {
          int userIndex = usersList
              .indexWhere((element) => element.uid == userCredential.user!.uid);
          if (userIndex != -1) {
            Future.delayed(Duration.zero, () {
              /// this could be from edit profile page or from home screen user icon available at the top right corner
              Provider.of<ProfileProvider>(RouteHelper.currentContext,
                      listen: false)
                  .saveUserProfile(usersList[userIndex]);
              String fromWhere = Provider.of<ProfileProvider>(
                      RouteHelper.currentContext,
                      listen: false)
                  .fromWhere;
              if (fromWhere == "home") {
                Navigator.of(RouteHelper.currentContext)
                    .pushNamedAndRemoveUntil(
                        RouteHelper.application, (route) => false);
              } else {
                /// this is from in App Purchase Bottom Sheet
                Fluttertoast.showToast(msg: "called");
                EasyLoadingDialog.dismiss(RouteHelper.currentContext);
                Navigator.of(RouteHelper.currentContext).pop("login");
              }
            });
          }
        }
      });
    } on FirebaseAuthException catch (e) {
      EasyLoadingDialog.dismiss(RouteHelper.currentContext);
      showErrorSnackBar(e.message.toString());
    } catch (e) {
      EasyLoadingDialog.dismiss(RouteHelper.currentContext);
    }
  }

  signUpWithEmailPassword(String email, String password, String name) async {
    try {
      Future.delayed(
          Duration.zero,
          () => EasyLoadingDialog.show(
              context: RouteHelper.currentContext, radius: 20.r));
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((userCredential) async {
        UserProfile userProfile = await setUserProfile(
            email: email,
            password: password,
            name: name,
            userCredential: userCredential,
            loginType: "email");
        Future.delayed(
            Duration.zero,
            () => Provider.of<ProfileProvider>(RouteHelper.currentContext,
                    listen: false)
                .uploadDataToFireStore(userCredential.user!.uid, userProfile));
      });
    } on FirebaseAuthException catch (e) {
      showErrorSnackBar(e.message.toString());
      EasyLoadingDialog.dismiss(RouteHelper.currentContext);
    } catch (e) {
      EasyLoadingDialog.dismiss(RouteHelper.currentContext);
    }
  }

  signInWithApple() {}

  signOutFromGoogle() async {
    await GoogleSignIn().signOut();
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseAuth.instance.signOut();
      changeLoginStatus();
    }
  }

  signOutFromFacebook() async {
    await FacebookAuth.instance.logOut();
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseAuth.instance.signOut();
      changeLoginStatus();
    }
  }

  signOutFromEmailPassword() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseAuth.instance.signOut();
      changeLoginStatus();
    }
  }

  changeLoginStatus() {
    Hive.box(appBoxKey).put(loginStatusString, 0);
  }

  Future<UserProfile> setUserProfile(
      {String? email,
      String? password,
      String? name,
      required UserCredential userCredential,
      required String loginType,
      String? image}) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print(androidInfo.id);
    OnBoardingInformation onBoarding =
        Hive.box(appBoxKey).get(onBoardingInformationKey);
    UserProfile userProfile = UserProfile(
        email: loginType == "email" ? email : userCredential.user!.email,
        password: loginType == "email" ? password : "",
        fullName:
            loginType == "email" ? name : userCredential.user!.displayName,
        image:
            loginType == "email" ? "" : image ?? userCredential.user!.photoURL,
        uid: userCredential.user!.uid,
        purposeOfQuran: onBoarding.purposeOfQuran,
        favReciter: onBoarding.favReciter,
        whenToReciterQuran: onBoarding.whenToReciterQuran,
        recitationReminder: onBoarding.recitationReminder,
        dailyQuranReadTime: onBoarding.dailyQuranReadTime,
        preferredLanguage: onBoarding.preferredLanguage!.languageCode,
        loginDevices: <String>[androidInfo.model],
        loginType: loginType);
    return userProfile;
  }

  showErrorSnackBar(String msg) {
    ScaffoldMessenger.of(RouteHelper.currentContext)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}

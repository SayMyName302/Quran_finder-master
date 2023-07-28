import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:nour_al_quran/pages/onboarding/models/on_boarding_information.dart';
import 'package:nour_al_quran/pages/recitation_category/pages/bookmarks_recitation.dart';
import 'package:nour_al_quran/pages/settings/pages/profile/user_profile.dart';
import 'package:nour_al_quran/shared/routes/routes_helper.dart';
import 'package:nour_al_quran/shared/utills/app_constants.dart';
import 'package:nour_al_quran/shared/widgets/easy_loading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared/entities/bookmarks.dart';
import '../../../shared/entities/reciters.dart';
import '../../../shared/localization/localization_provider.dart';
import '../../duas/models/dua.dart';
import '../../quran/pages/ruqyah/models/ruqyah.dart';
import '../../recitation_category/models/recitation_all_category_model.dart';
import '../../settings/pages/profile/profile_provider.dart';

class SignInProvider extends ChangeNotifier {
  String? _userEmail;
  String? get userEmail => _userEmail;

  signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? googleUser =
    await GoogleSignIn(scopes: <String>['email']).signIn();
    if (googleUser != null) {
      /// to show loading when user select any google account after clicking on google button
      Future.delayed(Duration.zero,
              () => EasyLoadingDialog.show(context: context, radius: 20.r));

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
          var doc = await FirebaseFirestore.instance.collection("users").get();
          List<UserProfile> usersList = doc.docs.map((e) => UserProfile.fromJson(e.data())).toList();

          /// if list is not empty means there are some users logged in to this app
          if (usersList.isNotEmpty) {
            /// now check whether this user uid is available in the list or not
            int userIndex = usersList.indexWhere((element) => element.uid == userCredential.user!.uid);
            if (userIndex != -1) {
              Future.delayed(Duration.zero, () {
                /// saving user profile model in local db
                Provider.of<ProfileProvider>(context, listen: false)
                    .saveUserProfile(usersList[userIndex]);

                FirebaseAnalytics.instance.logEvent(
                  name: 'google_login',
                );

                /// close loading dialog
                EasyLoadingDialog.dismiss(context);
                // Navigator.of(context).pushNamed(RouteHelper.completeProfile);

                /// save on boarding done and redirect user to application
                Hive.box(appBoxKey).put(onBoardingDoneKey, "done");
                RouteHelper.isLoggedIn = true;
                Navigator.of(context).pushNamedAndRemoveUntil(
                    RouteHelper.application, (route) => false);
              });
            } else {
              /// if user id Does not exist so create new user then and save data to fire store db
              print("----------------");
              UserProfile userProfile = await _setUserProfile(
                  userCredential: userCredential,
                  loginType: "google",
                  context: context
              );
              Future.delayed(
                  Duration.zero,
                      () => context.read<ProfileProvider>().uploadDataToFireStore(
                      userCredential.user!.uid, userProfile));
            }
          } else {
            /// else list is empty and it is the first use who logged in to this app
            UserProfile userProfile = await _setUserProfile(
                userCredential: userCredential,
                loginType: "google",
                context: context
            );
            Future.delayed(
                Duration.zero,
                    () => context.read<ProfileProvider>().uploadDataToFireStore(
                    userCredential.user!.uid, userProfile));
          }
        });
      } on FirebaseAuthException catch (e) {
        Future.delayed(Duration.zero, () {
          EasyLoadingDialog.dismiss(context);
          showErrorSnackBar(e.message.toString(), context);
        });
      } catch (e) {
        print(e);
        Future.delayed(Duration.zero, () {
          EasyLoadingDialog.dismiss(context);
          showErrorSnackBar(e.toString(), context);
        });
      }
    }
    // try {
    //   final GoogleSignInAccount? googleUser =
    //       await GoogleSignIn(scopes: <String>['email']).signIn();
    //   if (googleUser != null) {
    //     /// to show loading when user select any google account after clicking on google button
    //     Future.delayed(Duration.zero,
    //         () => EasyLoadingDialog.show(context: context, radius: 20.r));
    //
    //     /// google sign in code
    //     final GoogleSignInAuthentication googleSignInAuthentication =
    //         await googleUser.authentication;
    //     final credential = GoogleAuthProvider.credential(
    //         accessToken: googleSignInAuthentication.accessToken,
    //         idToken: googleSignInAuthentication.idToken);
    //
    //     /// firebase sign in with google account
    //     try {
    //       await FirebaseAuth.instance
    //           .signInWithCredential(credential)
    //           .then((userCredential) async {
    //         /// to check weather user exist in the existing list of fire store database
    //         var doc = await FirebaseFirestore.instance.collection("users").get();
    //         List<UserProfile> usersList = doc.docs.map((e) => UserProfile.fromJson(e.data())).toList();
    //
    //         /// if list is not empty means there are some users logged in to this app
    //         if (usersList.isNotEmpty) {
    //           /// now check whether this user uid is available in the list or not
    //           int userIndex = usersList.indexWhere((element) => element.uid == userCredential.user!.uid);
    //           if (userIndex != -1) {
    //             Future.delayed(Duration.zero, () {
    //               /// saving user profile model in local db
    //               Provider.of<ProfileProvider>(context, listen: false)
    //                   .saveUserProfile(usersList[userIndex]);
    //
    //               FirebaseAnalytics.instance.logEvent(
    //                 name: 'google_login',
    //               );
    //
    //               /// close loading dialog
    //               EasyLoadingDialog.dismiss(context);
    //               // Navigator.of(context).pushNamed(RouteHelper.completeProfile);
    //
    //               /// save on boarding done and redirect user to application
    //               Hive.box(appBoxKey).put(onBoardingDoneKey, "done");
    //               RouteHelper.isLoggedIn = true;
    //               Navigator.of(context).pushNamedAndRemoveUntil(
    //                   RouteHelper.application, (route) => false);
    //             });
    //           } else {
    //             /// if user id Does not exist so create new user then and save data to fire store db
    //             print("----------------");
    //             UserProfile userProfile = await _setUserProfile(
    //               userCredential: userCredential,
    //               loginType: "google",
    //               context: context
    //             );
    //             Future.delayed(
    //                 Duration.zero,
    //                 () => context.read<ProfileProvider>().uploadDataToFireStore(
    //                     userCredential.user!.uid, userProfile));
    //           }
    //         } else {
    //           /// else list is empty and it is the first use who logged in to this app
    //           UserProfile userProfile = await _setUserProfile(
    //             userCredential: userCredential,
    //             loginType: "google",
    //               context: context
    //           );
    //           Future.delayed(
    //               Duration.zero,
    //               () => context.read<ProfileProvider>().uploadDataToFireStore(
    //                   userCredential.user!.uid, userProfile));
    //         }
    //       });
    //     } on FirebaseAuthException catch (e) {
    //       Future.delayed(Duration.zero, () {
    //         EasyLoadingDialog.dismiss(context);
    //         showErrorSnackBar(e.message.toString(), context);
    //       });
    //     } catch (e) {
    //       print(e);
    //       Future.delayed(Duration.zero, () {
    //         EasyLoadingDialog.dismiss(context);
    //         showErrorSnackBar(e.toString(), context);
    //       });
    //     }
    //   }
    // } on PlatformException catch (e) {
    //   showErrorSnackBar(e.message!, context);
    //   print("/////////////// Google Login Exceptions ///////////////");
    //   print(e.message);
    // } catch (e) {
    //   showErrorSnackBar(e.toString(), context);
    // }
  }

  signInWithFaceBook(BuildContext context) async {
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

              /// if there was no user available in db with this id
              if (userIndex != -1) {
                Future.delayed(Duration.zero, () {
                  /// this could be from edit profile page or from home screen user icon available at the top right corner
                  Provider.of<ProfileProvider>(context, listen: false)
                      .saveUserProfile(usersList[userIndex]);

                  /// close loading dialog
                  EasyLoadingDialog.dismiss(context);

                  /// save on boarding done and redirect user to application
                  Hive.box(appBoxKey).put(onBoardingDoneKey, "done");
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      RouteHelper.application, (route) => false);
                });
              } else {
                /// so add new user to fire store db
                UserProfile userProfile = await _setUserProfile(
                    userCredential: userCredential,
                    loginType: "facebook",
                    image: data["picture"]['data']['url'],
                    context: context
                );

                Future.delayed(
                    Duration.zero,
                    () => context.read<ProfileProvider>().uploadDataToFireStore(
                        userCredential.user!.uid, userProfile));
              }
            } else {
              /// this else block will execute if there were no user in fire store db and this one user is the first user
              /// other wise it will not be executed
              UserProfile userProfile = await _setUserProfile(
                  userCredential: userCredential,
                  loginType: "facebook",
                  image: data["picture"]['data']['url'],
                  context: context
              );
              Future.delayed(
                  Duration.zero,
                  () => context.read<ProfileProvider>().uploadDataToFireStore(
                      userCredential.user!.uid, userProfile));
            }
          });
        } on FirebaseAuthException catch (e) {
          Future.delayed(Duration.zero, () {
            EasyLoadingDialog.dismiss(context);
            showErrorSnackBar(e.toString(), context);
          });
        } catch (e) {
          Future.delayed(Duration.zero, () {
            EasyLoadingDialog.dismiss(context);
            showErrorSnackBar(e.toString(), context);
          });
        }
      }
    } on PlatformException catch (e) {
      showErrorSnackBar(e.message!, context);
    }
  }

  /// sign in user
  signInWithEmailPassword(
      String email, String password, BuildContext context) async {
    try {
      Future.delayed(Duration.zero,
          () => EasyLoadingDialog.show(context: context, radius: 20.r));
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        var doc = await FirebaseFirestore.instance.collection("users").get();
        List<UserProfile> usersList = doc.docs.map((e) => UserProfile.fromJson(e.data())).toList();
        int index = usersList.indexWhere((element) => element.uid == value.user!.uid);
        if (index != -1) {
          //storing user email to userEmail variable to check for email you@you.com
          //storing user email to userEmail variable to check for email you@you.com
          _userEmail = value.user?.email; // Update the private variable
          // Save the userEmail to SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(
              'user_email', _userEmail ?? ''); // Use ?? '' to handle null case
          // print('=====UserEmail{$userEmail}======');

          Future.delayed(Duration.zero, () {
            /// save user profile in local db
            Provider.of<ProfileProvider>(context, listen: false)
                .saveUserProfile(usersList[index]);

            /// close loading dialog
            // EasyLoadingDialog.dismiss(context);

            /// save on boarding done and redirect user to application
            Hive.box(appBoxKey).put(onBoardingDoneKey, "done");
            Navigator.of(context).pushNamedAndRemoveUntil(
                RouteHelper.application, (route) => false);
          });
        } else {
          Future.delayed(Duration.zero, () {
            EasyLoadingDialog.dismiss(context);
            showErrorSnackBar("No User Found With This Email", context);
          });
        }
      });
    } on FirebaseAuthException catch (e) {
      EasyLoadingDialog.dismiss(context);
      showErrorSnackBar(e.message.toString(), context);
    } catch (e) {
      EasyLoadingDialog.dismiss(context);
    }
  }

//To store and fetch userEmail locally
  SignInProvider() {
    initUserEmail();
  }

  Future<void> initUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userEmail = prefs.getString('user_email');
    notifyListeners();
  }

  // Setter to update the userEmail
  set userEmail(String? email) {
    _userEmail = email;
    // Save the userEmail to SharedPreferences
    saveUserEmail(email);
    notifyListeners();
  }

  Future<void> saveUserEmail(String? email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_email', email ?? '');
  }

  signUpWithEmailPassword(String email, String password, String name, BuildContext context) async {
    try {
      Future.delayed(Duration.zero,
          () => EasyLoadingDialog.show(context: context, radius: 20.r));
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((userCredential) async {
        UserProfile userProfile = await _setUserProfile(
            email: email,
            password: password,
            name: name,
            userCredential: userCredential,
            loginType: "email",
            context: context
        );
        Future.delayed(
            Duration.zero,
            () => Provider.of<ProfileProvider>(context, listen: false)
                .uploadDataToFireStore(userCredential.user!.uid, userProfile));
      });
    } on FirebaseAuthException catch (e) {
      showErrorSnackBar(e.message.toString(), context);
      EasyLoadingDialog.dismiss(context);
    } catch (e) {
      EasyLoadingDialog.dismiss(context);
    }
  }

  signInWithApple() {}

  signOutFromGoogle() async {
    await GoogleSignIn().signOut();
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseAuth.instance.signOut();
      changeLoginStatus();
    }
    RouteHelper.isLoggedIn = false;
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

  Future<UserProfile> _setUserProfile(
      {String? email,
      String? password,
      String? name,
      required UserCredential userCredential,
      required String loginType,
      String? image,required BuildContext context
      }) async {
    UserProfile userProfile = Provider.of<ProfileProvider>(context,listen: false).userProfile!;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    userProfile.setEmail = (loginType == "email" ? email : userCredential.user!.email)!;
    userProfile.setFullName = (loginType == "email" ? name : userCredential.user!.displayName)!;
    userProfile.setPassword = (loginType == "email" ? password : "")!;
    userProfile.setImage = (loginType == "email" ? "" : image ?? userCredential.user!.photoURL)!;
    userProfile.setUid = userCredential.user!.uid;
    // userProfile.setPurposeOfQuran = [];
    userProfile.setLoginDevices = <Devices>[
      Devices(name: androidInfo.model, datetime: DateTime.now().toIso8601String())
    ];
    // userProfile.setPreferredLanguage = LocalizationProvider().locale.languageCode;
    userProfile.setLoginType = loginType;





    // UserProfile userProfile = UserProfile(
    //     email: loginType == "email" ? email : userCredential.user!.email,
    //     password: loginType == "email" ? password : "",
    //     fullName: loginType == "email" ? name : userCredential.user!.displayName,
    //     image: loginType == "email" ? "" : image ?? userCredential.user!.photoURL,
    //     uid: userCredential.user!.uid,
    //     purposeOfQuran: onBoarding.purposeOfQuran,
    //     preferredLanguage: onBoarding.preferredLanguage!.languageCode,
    //     loginDevices: <Devices>[
    //       Devices(name: androidInfo.model, datetime: DateTime.now().toIso8601String())
    //     ],
    //     loginType: loginType,
    //     favRecitersList: <Reciters>[],
    //     quranBookmarksList: <Bookmarks>[],
    //     duaBookmarksList: <Dua>[],
    //     ruqyahBookmarksList: <Ruqyah>[],
    //     recitationBookmarkList: <BookmarksRecitation>[]
    //     /// changes
    //     // whenToReciterQuran: onBoarding.whenToReciterQuran,
    //     // recitationReminder: onBoarding.recitationReminder,
    //     // dailyQuranReadTime: onBoarding.dailyQuranReadTime,
    //     );
    return userProfile;
  }

  resetPassword({required String email, required BuildContext context}) async {
    try {
      Future.delayed(Duration.zero,
          () => EasyLoadingDialog.show(context: context, radius: 20.r));
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email)
          .then((value) {
        showErrorSnackBar(
            "An Email is sent to you, Please check your mail", context);
        EasyLoadingDialog.dismiss(context);
        Navigator.of(context).pop();
      });
    } on FirebaseAuthException catch (e) {
      EasyLoadingDialog.dismiss(context);
      showErrorSnackBar(e.message.toString(), context);
    } catch (e) {
      EasyLoadingDialog.dismiss(context);
    }
  }

  showErrorSnackBar(String msg, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}



// String fromWhere = Provider.of<ProfileProvider>(context, listen: false).fromWhere;
// if (fromWhere == "home") {
//   Navigator.of(context).pushNamedAndRemoveUntil(RouteHelper.application, (route) => false);
// } else {
//   /// this is from in App Purchase Bottom Sheet
//   EasyLoadingDialog.dismiss(context);
//   Navigator.of(context).pop("login");
// }
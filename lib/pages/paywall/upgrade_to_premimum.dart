import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nour_al_quran/shared/localization/localization_constants.dart';
import 'package:nour_al_quran/shared/routes/routes_helper.dart';
import 'package:nour_al_quran/shared/utills/app_colors.dart';
import 'package:nour_al_quran/shared/widgets/app_bar.dart';
import 'package:nour_al_quran/shared/widgets/brand_button.dart';
import 'package:nour_al_quran/shared/widgets/title_row.dart';
import 'package:provider/provider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:nour_al_quran/pages/paywall/paywal_provider.dart';

class paywall extends StatelessWidget {
  const paywall({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildpaywallappbar(
          context: context,
          title: localeText(context, "upgrade_to_premium"),
          icon: ""),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                child: Text(
                  localeText(
                    context,
                    'get_the_premium_today_and_enjoy_unlimited_access_to_the_quran_pro_app',
                  ),
                  style: TextStyle(
                      fontFamily: 'satoshi',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500),
                )),
            SizedBox(
              height: 15.h,
            ),
            const CardSection(),
            SizedBox(
              height: 15.h,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  localeText(
                    context,
                    'plans_specially_curated_for_you',
                  ),
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'satoshi',
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold),
                )),
            const pricetile(),
            const PrimePlanContainer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(localeText(context, 'recurring_billing_cancel_anytime'),
                    style: TextStyle(
                      color: AppColors.grey3,
                      fontFamily: 'satoshi',
                      fontSize: 12.sp,
                    )),
              ],
            ),
            SizedBox(
              height: 15.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                          localeText(
                            context,
                            'your_subscription_will_automatically_renew_for_the_same_purchasing_program_at_the_same_time',
                          ),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.grey3,
                            fontFamily: 'satoshi',
                            fontSize: 12.sp,
                          ))),
                ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  localeText(
                    context,
                    'success_stories',
                  ),
                  style: TextStyle(
                      fontFamily: 'satoshi',
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold),
                )),
            SuccessStoriesList(context: context),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  localeText(context, 'frequently_asked_questions'),
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'satoshi',
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold),
                )),
            const FAQList(),
          ],
        ),
      ),
    );
  }
}

Future<List<DocumentSnapshot>> getDataFromFirebase() async {
  final snapshot =
      await FirebaseFirestore.instance.collection('paywalldata').get();
  return snapshot.docs;
}

class pricetile extends StatelessWidget {
  const pricetile({super.key});

  @override
  Widget build(BuildContext context) {
    PremiumScreenProvider priceProvider =
        Provider.of<PremiumScreenProvider>(context);
    int focusedIndex = priceProvider.focusedIndex;

    return FutureBuilder<List<DocumentSnapshot>>(
      future: getDataFromFirebase(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SizedBox(
              height: 190.0,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: buildContainer(
                        context,
                        focusedIndex,
                        0,
                        data![0][
                            'title'], // Update with the actual field names in your Firebase document
                        data[0][
                            'price'], // Update with the actual field names in your Firebase document
                        data[0][
                            'perMonthPrice'], // Update with the actual field names in your Firebase document
                        data[0][
                            'discount'], // Update with the actual field names in your Firebase document
                        Colors.green,
                        '',
                        Colors.white,
                        AppColors.darkColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      fit: FlexFit.tight,
                      child: buildContainer(
                        context,
                        focusedIndex,
                        1,
                        data[1][
                            'title'], // Update with the actual field names in your Firebase document
                        data[1][
                            'price'], // Update with the actual field names in your Firebase document
                        data[1][
                            'perMonthPrice'], // Update with the actual field names in your Firebase document
                        data[1][
                            'discount'], // Update with the actual field names in your Firebase document
                        Colors.white,
                        data[1][
                            'trialText'], // Update with the actual field names in your Firebase document
                        AppColors.primeBlue,
                        AppColors.lightBrandingColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      fit: FlexFit.tight,
                      child: buildContainer(
                        context,
                        focusedIndex,
                        2,
                        data[2][
                            'title'], // Update with the actual field names in your Firebase document
                        data[2][
                            'price'], // Update with the actual field names in your Firebase document
                        'No Trial',
                        'No Discount',
                        Colors.red,
                        '',
                        Colors.white,
                        AppColors.darkColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
            AppColors.mainBrandingColor,
          )));
        }
      },
    );
  }
}

Widget buildContainer(
  BuildContext context,
  int focusedIndex,
  int index,
  String durationText,
  String priceText,
  String subscriptionText,
  String discountText,
  Color smallContainerColor,
  String trialText,
  Color containerColor,
  Color textcolor,
) {
  final isFocused = focusedIndex == index;
  final appColors = isFocused ? AppColors.primeBlue : AppColors.grey6;
  final brandingColor =
      isFocused ? AppColors.lightBrandingColor : AppColors.mainBrandingColor;

  return GestureDetector(
    onTap: () {
      Provider.of<PremiumScreenProvider>(context, listen: false).setFocusedIndex(index);
      if(index == 0)
      {
        OneSignal.shared.sendTag("Subscription type", "Half year subscribers");
        OneSignal.shared.sendTag("Total Months as a subscriber", "6");
        
      }
      else if(index == 1)
      {
        
        OneSignal.shared.sendTag("Subscription type", "Premium Subscribers (Full year)");
        OneSignal.shared.sendTag("Total Months as a subscriber", "12");

      }
      else if(index == 2)
      {
        OneSignal.shared.sendTag("Subscription type", "Monthly subscribers");
        OneSignal.shared.sendTag("Total Months as a subscriber", "1");
      }
      else
      {
        
      }

    },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isFocused ? 130 : 110,
      height: isFocused ? 150 : 130,
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: appColors,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            durationText,
            style: TextStyle(
              color: textcolor,
              fontFamily: 'satoshi',
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            priceText,
            style: TextStyle(
              color: index == 1
                  ? AppColors.lightBrandingColor
                  : AppColors.mainBrandingColor,
              fontFamily: 'satoshi',
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subscriptionText,
            style: TextStyle(
              color: textcolor,
              fontFamily: 'satoshi',
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            width: 75,
            height: 17,
            decoration: BoxDecoration(
              color: smallContainerColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                discountText,
                style: TextStyle(
                  color: index == 1
                      ? AppColors.primeBlue
                      : AppColors.lightBrandingColor,
                  fontFamily: 'satoshi',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (trialText.isNotEmpty)
            Text(
              trialText,
              style: TextStyle(
                color: textcolor,
                fontFamily: 'satoshi',
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    ),
  );
}

class CardSection extends StatelessWidget {
  const CardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PremiumScreenProvider>(
      builder: (context, upgradeProvider, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.mainBrandingColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      localeText(
                        context,
                        'limited_time_offer_for_unlimited_perks_&',
                      ),
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'satoshi',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Center(
                    child: Text(
                      localeText(
                        context,
                        'benefits',
                      ),
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'satoshi',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Container(
                      height: 29.h,
                      width: 150.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              localeText(
                                context,
                                'ends_in',
                              ),
                              style: TextStyle(
                                fontFamily: 'satoshi',
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "3:00",
                              style: TextStyle(
                                fontFamily: 'satoshi',
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                              ),
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
      },
    );
  }
}

//for texts in the container

class PrimePlanContainer extends StatelessWidget {
  const PrimePlanContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.grey5, // Set the border color here
            width: 1, // Set the border width
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Center(
                  child: Text(
                localeText(
                  context,
                  'prime_plan',
                ),
                style: TextStyle(
                    fontFamily: 'satoshi',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500),
              )),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.check_circle_rounded,
                          color: AppColors.googleColor),
                      SizedBox(width: 8.w),
                      Flexible(
                          child: Text(
                        localeText(
                          context,
                          'no_ads',
                        ),
                        style: TextStyle(
                          fontFamily: 'satoshi',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      const Icon(Icons.check_circle_rounded,
                          color: AppColors.googleColor),
                      SizedBox(width: 8.w),
                      Flexible(
                          child: Text(
                        localeText(
                          context,
                          'unlock_bedtime_quran_stories_to_cleanse_your_thoughts',
                        ),
                        style: TextStyle(
                          fontFamily: 'satoshi',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      const Icon(Icons.check_circle_rounded,
                          color: AppColors.googleColor),
                      SizedBox(width: 8.w),
                      Flexible(
                          child: Text(
                        localeText(
                          context,
                          'unlock_soothing_recitation_of_the_quran_to_calm_your_mind',
                        ),
                        style: TextStyle(
                          fontFamily: 'satoshi',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      const Icon(Icons.check_circle_rounded,
                          color: AppColors.googleColor),
                      SizedBox(width: 8.w),
                      Flexible(
                          child: Text(
                        localeText(
                          context,
                          'unlock_1000_ duas_to_protect_you_from_jahannum',
                        ),
                        style: TextStyle(
                          fontFamily: 'satoshi',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: BrandButton(
                    text: localeText(context, "start_free_trial"),
                    onTap: () {
                      OneSignal.shared.sendTag("Subscription Status", "Free trial users");
                      Navigator.of(context).pushNamed(RouteHelper.paywallscreen2);
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SuccessStoriesList extends StatelessWidget {
  final BuildContext context; // Add this line
  final List<UserModel> successStories;
  SuccessStoriesList({required this.context})
      : successStories = [
          UserModel(
              name: 'Ali Muhammad',
              rating: '4.5',
              avatarUrl: 'assets/images/app_icons/male1.png',
              description: localeText(context,
                  'love_it!_this_app_has_helped_me_calm_myself._the_recitation_of_the_quran_captivates_me_and_makes_me_want_to_put_down_my_work_and_listen_to_the_whole_chapter._every_time_i_feel_depressed_or_restless_i_come_back_here_to_listen_to_the_recitations.')),
          UserModel(
              name: 'Usman Mirza',
              rating: '4.9',
              avatarUrl: 'assets/images/app_icons/male2.png',
              description: localeText(context,
                  'this_app_was_referred_by_a_friend._he_told_me_that_listening_to_recitations_on_this_app_will_help_cure_insomnia._when_i_opened_this_app_and_saw_the_huge_library_of_quran_recitations_and_stories,_ i_was_blown_away._i think_it_might_have_a_different_story_for_each_day_of_the_month.')),

          UserModel(
              name: 'Nadir Ahmed',
              rating: '4.5',
              avatarUrl: 'assets/images/app_icons/male3.png',
              description: localeText(context,
                  'the_prime_plan_is_awesome!_it_has_no_ads_and_unlocks_hundreds_of_extra_stories._i_can_listen_to_the_recitations_and_stories_from_the_quran_here,_all_day_and_not_get_tired.')),
          // UserModel(
          //   name: 'Jane Smith',
          //   rating: '4.0',
          //   avatarUrl: 'assets/images/app_icons/avatar.png',
          //   description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
          // ),
          // Add more success stories here
        ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: successStories.length,
        itemBuilder: (context, index) {
          final user = successStories[index];
          return SuccessStoryCard(user: user);
        },
      ),
    );
  }
}

class SuccessStoryCard extends StatelessWidget {
  final UserModel user;

  const SuccessStoryCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.grey5, // Set the border color here
            width: 1, // Set the border width
          ),
        ),
        width: 290.w,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(user.avatarUrl),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/app_icons/Star.svg',
                          width: 20.w,
                          height: 20.h,
                        ),
                        Text(user.rating),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Flexible(
              // or Expanded
              child: Text(
                user.description,
                overflow: TextOverflow.fade, // or TextOverflow.ellipsis
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FAQList extends StatelessWidget {
  const FAQList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FAQItem(
            question: localeText(
                context, 'i_downloaded_the_app,_am_i_going_to_be_charged?'),
            answer: localeText(context,
                '''we_provide_our_users_wtih_a_free_versions,_as_well_as_a_paid_version._the_paid_version_unlocks_more_stories_and_recitations_of_the_quran.''')),
        FAQItem(
            question: localeText(context, 'how_can_i_cancel_my_subscription?'),
            answer: localeText(context,
                '''if_you_downloaded_the_app_through_an_ios_device:_cancel_the_subscription_via_apple_and_if_you_downloaded_the_app_via_an_andriod_device:_cancel_the_subscription_from_google''')),
        FAQItem(
            question: localeText(
                context, 'how_can_i_access_premium_plan_on_multiple_devices?'),
            answer: localeText(context,
                '''we_advise_you_to_make_an_account_to_access_the_premium_plan_on_multiple_devices._open_the_app._go_to_the_link_that_says_enter_your_email._input_your_email._once_you_have_entered_your_email_address,_click_next_to_continue._you_will_get_an_email_with_a_login_link._please_be_sure_that_you_have_access_to_this_email_address_on_the_device_you_plan_to_use._tap_on_the_link,_and_you_will_be_redirected_to_the_app_and_logged_into_your_existing_account,''')),
        FAQItem(
            question: localeText(context, 'will_i_get_a_refund?'),
            answer: localeText(context,
                "if_you_have_purchased_our_subscription_via_google_play_store,_google_will_process_refunds_only_if_it's_less_than_48_hours_after_signing_up_or_making_an_in-app_purchase.")),
        FAQItem(
            question: localeText(
                context, 'how_can_i_unsubscribe_from_promotional_emails?'),
            answer: localeText(context,
                "you_can_unsubscribe_from_our_promotional_emails_whenever_you_want_by_scrolling_down_to_the_bottom_of_the_email_and_clicking_on _the_unsubscribe_link._we_will_not_send_you_any_promotional_emails_once_you_have_unsubscribed_yourself."))
        // Add more FAQ items here
      ],
    );
  }
}

class FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const FAQItem({super.key, required this.question, required this.answer});

  @override
  _FAQItemState createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.grey5, // Set the border color here
            width: 1, // Set the border width
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(widget.question,
                        style: TextStyle(
                            fontFamily: 'satoshi',
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  icon: SvgPicture.asset(
                    isExpanded
                        ? 'assets/images/app_icons/DropDown.svg'
                        : 'assets/images/app_icons/DropDown.svg',
                  ),
                ),
              ],
            ),
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
                child: Text(widget.answer),
              ),
          ],
        ),
      ),
    );
  }
}

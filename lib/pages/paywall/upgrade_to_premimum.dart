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

import 'package:nour_al_quran/pages/paywall/paywal_provider.dart';

class paywall extends StatelessWidget {
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
                'Get the premium today and enjoy unlimited access to the Quran App',
                style: TextStyle(
                    fontFamily: 'satoshi',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            CardSection(),
            SizedBox(
              height: 15.h,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                'Plans specially curated for you',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'satoshi',
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
            pricetile(),
            PrimePlanContainer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Recurring billing , Cancel Anytime',
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
                        'Your subscription will automatically renew for the same purchasing program at the same time',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.grey3,
                          fontFamily: 'satoshi',
                          fontSize: 12.sp,
                        )),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Success Stories',
                style: TextStyle(
                    fontFamily: 'satoshi',
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SuccessStoriesList(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Frequently Asked Questions',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'satoshi',
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
            FAQList(),
          ],
        ),
      ),
    );
  }
}

Future<List<DocumentSnapshot>> getDataFromFirebase() async {
  final snapshot = await FirebaseFirestore.instance.collection('paywalldata').get();
  return snapshot.docs;
}

class pricetile extends StatelessWidget {
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
            child: Container(
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
      Provider.of<PremiumScreenProvider>(context, listen: false)
          .setFocusedIndex(index);
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
                      'Limited Time Offer for Unlimited Perks & ',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'satoshi',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Benefits',
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
                        child: Text(
                          'Ends in 3:00',
                          style: TextStyle(
                              fontFamily: 'satoshi',
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500),
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
                  'Prime Plan',
                  style: TextStyle(
                      fontFamily: 'satoshi',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500),
                ),
              ),
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
                      const SizedBox(width: 8),
                      Text(
                        'No ads',
                        style: TextStyle(
                            fontFamily: 'satoshi',
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.check_circle_rounded,
                          color: AppColors.googleColor),
                      const SizedBox(width: 8),
                      Text('Lorem ipsum',
                          style: TextStyle(
                              fontFamily: 'satoshi',
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.check_circle_rounded,
                          color: AppColors.googleColor),
                      const SizedBox(width: 8),
                      Text('Lorem ipsum',
                          style: TextStyle(
                              fontFamily: 'satoshi',
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.check_circle_rounded,
                          color: AppColors.googleColor),
                      const SizedBox(width: 8),
                      Text('Lorem ipsum',
                          style: TextStyle(
                              fontFamily: 'satoshi',
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: BrandButton(
                    text: localeText(context, "start_free_trial"),
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(RouteHelper.paywallscreen2);
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
  final List<UserModel> successStories = [
    UserModel(
      name: 'John Doe',
      rating: '4.5',
      avatarUrl: 'assets/images/app_icons/avatar.png',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit.Lorem ipsum dolor sit amet, consectetur adipiscing elit.Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
    ),
    UserModel(
      name: 'Jane Smith',
      rating: '4.0',
      avatarUrl: 'assets/images/app_icons/avatar.png',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
    ),
    UserModel(
      name: 'Jane Smith',
      rating: '4.0',
      avatarUrl: 'assets/images/app_icons/avatar.png',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
    ),
    UserModel(
      name: 'Jane Smith',
      rating: '4.0',
      avatarUrl: 'assets/images/app_icons/avatar.png',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
    ),
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

  const SuccessStoryCard({required this.user});

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
                  radius: 30,
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
                            width: 20.w,
                            height: 20.h,
                            'assets/images/app_icons/Star.svg'),
                        Text(user.rating),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(user.description),
          ],
        ),
      ),
    );
  }
}

class FAQList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FAQItem(
            question:
                '"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmint nim id est laborum."',
            answer:
                '''Anr3qrq3rrrrrrrrrrrrrrrrswer 1Anr3qrq3rrrrrrrrrrrrrrrrswer 
                Anr3qrq3rrrrrrrrrrrrrrrrswer 1
                Anr3qrq3rrrrrrrrrrrrrrrrswer 1
                Anr3qrq3rrrrrrrrrrrrrrrrswer 11Anr3qrq3rrrrrrrrrrrrrrrrswer 1Anr3qrq3rrrrrrrrrrrrrrrrswer 1'''),
        FAQItem(
            question:
                '"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmint nim id est laborum."',
            answer:
                '''Anr3qrq3rrrrrrrrrrrrrrrrswer 1Anr3qrq3rrrrrrrrrrrrrrrrswer 
                Anr3qrq3rrrrrrrrrrrrrrrrswer 1
                Anr3qrq3rrrrrrrrrrrrrrrrswer 1
                Anr3qrq3rrrrrrrrrrrrrrrrswer 11Anr3qrq3rrrrrrrrrrrrrrrrswer 1Anr3qrq3rrrrrrrrrrrrrrrrswer 1'''),
        FAQItem(
            question:
                '"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmint nim id est laborum."',
            answer:
                '''Anr3qrq3rrrrrrrrrrrrrrrrswer 1Anr3qrq3rrrrrrrrrrrrrrrrswer 
                Anr3qrq3rrrrrrrrrrrrrrrrswer 1
                Anr3qrq3rrrrrrrrrrrrrrrrswer 1
                Anr3qrq3rrrrrrrrrrrrrrrrswer 11Anr3qrq3rrrrrrrrrrrrrrrrswer 1Anr3qrq3rrrrrrrrrrrrrrrrswer 1'''),
        FAQItem(
            question:
                '"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmint nim id est laborum."',
            answer:
                '''Anr3qrq3rrrrrrrrrrrrrrrrswer 1Anr3qrq3rrrrrrrrrrrrrrrrswer 
                Anr3qrq3rrrrrrrrrrrrrrrrswer 1
                Anr3qrq3rrrrrrrrrrrrrrrrswer 1
                Anr3qrq3rrrrrrrrrrrrrrrrswer 11Anr3qrq3rrrrrrrrrrrrrrrrswer 1Anr3qrq3rrrrrrrrrrrrrrrrswer 1''')
        // Add more FAQ items here
      ],
    );
  }
}

class FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});

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
                padding: const EdgeInsets.only(left: 16),
                child: Text(widget.answer),
              ),
          ],
        ),
      ),
    );
  }
}

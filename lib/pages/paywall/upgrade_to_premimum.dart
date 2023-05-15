import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/shared/localization/localization_constants.dart';
import 'package:nour_al_quran/shared/utills/app_colors.dart';
import 'package:nour_al_quran/shared/widgets/brand_button.dart';
import 'package:nour_al_quran/shared/widgets/title_row.dart';
import 'package:provider/provider.dart';

import 'package:nour_al_quran/pages/paywall/paywal_provider.dart';

class paywall extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
          context: context, title: localeText(context, "upgrade_to_premium")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Get the premium today and enjoy unlimited access to the Quran App',
                style: TextStyle(
                    fontFamily: 'satoshi',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500),
              ),
            ),
            CardSection(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Plans specially curated for you',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'satoshi',
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
            PlansList(),
            PrimePlanContainer(),
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

class CardSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PremiumScreenProvider>(
      builder: (context, upgradeProvider, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
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

class PlansList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        PriceTile(index: 0),
        PriceTile(index: 1),
        PriceTile(index: 2),
      ],
    );
  }
}

class PriceTile extends StatelessWidget {
  final int index;

  PriceTile({required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final containerProvider =
            Provider.of<PremiumScreenProvider>(context, listen: false);
        containerProvider.updateTappedIndex(index);
      },
      child: Consumer<PremiumScreenProvider>(
        builder: (context, containerProvider, _) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: containerProvider.tappedIndex == index ? 120 : 110,
            height: containerProvider.tappedIndex == index ? 160 : 150,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: containerProvider.tappedIndex == index
                    ? Colors.blue
                    : AppColors.grey5,
                width: 1,
              ),
            ),
            child: containerProvider.tappedIndex == index
                ? const Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                    ),
                  )
                : null,
          );
        },
      ),
    );
  }
}

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
                      const Icon(Icons.check, color: Colors.green),
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
                  Row(
                    children: [
                      const Icon(Icons.check, color: Colors.green),
                      const SizedBox(width: 8),
                      Text('Lorem ipsum',
                          style: TextStyle(
                              fontFamily: 'satoshi',
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.check, color: Colors.green),
                      const SizedBox(width: 8),
                      Text('Lorem ipsum',
                          style: TextStyle(
                              fontFamily: 'satoshi',
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.check, color: Colors.green),
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
                    text: localeText(context, "continue"),
                    onTap: () {
                      // Navigator.of(context).pushNamed(RouteHelper.completeProfile);
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
                        const Icon(Icons.star, color: Colors.yellow),
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
                  icon: Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
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

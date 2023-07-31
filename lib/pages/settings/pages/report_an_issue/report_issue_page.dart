import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/shared/localization/localization_constants.dart';
import 'package:nour_al_quran/shared/utills/app_colors.dart';
import 'package:nour_al_quran/shared/widgets/brand_button.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../../shared/widgets/app_bar.dart';

class ReportIssuePage extends StatefulWidget {
  const ReportIssuePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ReportIssuePageState createState() => _ReportIssuePageState();
}

class _ReportIssuePageState extends State<ReportIssuePage> {
  final ValueNotifier<String> selectedOption =
      ValueNotifier("Request a Feature");
  int _selectedOptionIndex = -1;

  List<String> options = [
    "Report an issue",
    "Add a new feature",
    "Add specific content to app",
  ];

  @override
  Widget build(BuildContext context) {
    var style14 = TextStyle(
        fontFamily: 'satoshi', fontSize: 14.sp, fontWeight: FontWeight.w400);
    final descriptionController = TextEditingController();
    final emailController = TextEditingController();

    return Scaffold(
      appBar: buildAppBar(
          context: context, title: localeText(context, "report_an_issue")),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 20.h, right: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Please let us know what you’d like to do",
                style: style14,
              ),
              Container(
                margin: EdgeInsets.only(top: 7.h, bottom: 13.h),
                padding: EdgeInsets.only(left: 10.w, right: 21.w),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(color: AppColors.grey5)),
                child: ExpansionTile(
                  title: Text(
                    selectedOption.value,
                    style: TextStyle(
                      fontFamily: 'satoshi',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onExpansionChanged: (isExpanded) {
                    if (isExpanded) {
                      _selectedOptionIndex = -1;
                    } else {
                      if (_selectedOptionIndex != -1) {
                        selectedOption.value = options[_selectedOptionIndex];
                      }
                    }
                  },
                  children: [
                    for (int i = 0; i < options.length; i++)
                      _buildExpansionOption(i, options[i]),
                  ],
                ),
              ),
              Text(
                "Description",
                style: style14,
              ),
              Container(
                  margin: EdgeInsets.only(top: 7.h),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(color: AppColors.grey5)),
                  child: TextField(
                    controller: descriptionController,
                    maxLines: 8,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          top: 13.h, left: 10.w, right: 10.w, bottom: 13.h),
                      hintText: "Add details",
                      hintStyle: style14,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none,
                    ),
                  )),
              Container(
                  margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
                  child: Text(
                    "Your Email",
                    style: style14,
                  )),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColors.grey5),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColors.grey5),
                      borderRadius: BorderRadius.circular(6.r),
                    )),
              ),
              Container(
                  margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
                  child: BrandButton(
                      text: "Submit",
                      onTap: () {
                        String subject = "Issue Report";
                        String body =
                            "Description: ${descriptionController.text}\n"
                            "Email: ${emailController.text}";
                        sendEmail(subject, body);
                      }))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpansionOption(int index, String title) {
    var style14 = TextStyle(
      fontFamily: 'satoshi',
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
    );

    return InkWell(
      onTap: () {
        setState(() {
          selectedOption.value = title;
          _selectedOptionIndex = index;
        });
      },
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.all(10.h),
        margin: EdgeInsets.only(bottom: 2.h),
        color: _selectedOptionIndex == index
            ? AppColors.grey5
            : Colors.transparent,
        child: Text(
          title,
          style: style14,
        ),
      ),
    );
  }
}

void sendEmail(String subject, String body) async {
  final String? gmailUsername = dotenv.env['GMAIL_USERNAME'];
  final String? gmailPassword = dotenv.env['GMAIL_PASSWORD'];

  if (gmailUsername != null && gmailPassword != null) {
    final smtpServer = SmtpServer(
      'smtp.gmail.com',
      username: gmailUsername,
      password: gmailPassword,
      ssl: true,
      port: 465,
    );

    final message = Message()
      ..from = Address(gmailUsername)
      ..recipients.add("sohaila.tabusum@gmail.com")
      ..subject = subject
      ..text = body;

    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'No internet connection');
    } else {
      try {
        final sendReport = await send(message, smtpServer);
        print('Message sent: ${sendReport.toString()}');
        Fluttertoast.showToast(msg: 'Response submitted successfully');
      } on MailerException catch (e) {
        print('Message not sent. Error: ${e.toString()}');
        Fluttertoast.showToast(msg: 'Failed to send email');
      }
    }
  } else {
    print('Error: Gmail credentials not found or incomplete.');
  }
}

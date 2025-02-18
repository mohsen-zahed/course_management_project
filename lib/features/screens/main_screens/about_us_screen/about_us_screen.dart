import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:course_management_project/config/constants/images_paths.dart';
import 'package:course_management_project/helpers/theme_helpers.dart';
import 'package:course_management_project/packages/flushbar_package/flushbar_package.dart';
import 'package:course_management_project/utils/app_theme.dart';
import 'package:course_management_project/utils/media_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutUsScreen extends StatelessWidget {
  static const String id = '/about_us_screen';
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isThemeLight(context) ? kGreyColor50 : kGreyColor900,
      appBar: AppBar(title: const Text('درباره ما')),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isThemeLight(context) ? kWhiteColor : kGreyColor800,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Hero(
                  tag: 'idea_logo',
                  child: Image.asset(
                    ImagesPaths.tawanaWhiteLogoJpg,
                    fit: BoxFit.cover,
                    width: sizeConstants.imageLarge,
                    height: sizeConstants.imageLarge,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const IntroText(
                text:
                    'آکادمی توانا در تاریخ ۸ قوس ۱۴۰۰ توسط عبدالقدوس مختارزاده تأسیس شد و از آن زمان تاکنون به‌عنوان یکی از مراکز پیشرو در آموزش زبان انگلیسی فعالیت دارد. این آکادمی با تکیه بر منابع معتبر و به‌روز، از جمله ویرایش سوم مجموعه American English File، و با بهره‌گیری از روش‌های نوین و کاربردی تدریس، محیطی پویا و حرفه‌ای را برای زبان‌آموزان در تمامی سطوح فراهم کرده است.',
              ),
              const SizedBox(height: 10),
              const IntroText(
                text:
                    'آکادمی توانا با رویکردی علمی و مدرن، یادگیری زبان انگلیسی را تسهیل کرده و با ارائه برنامه‌های آموزشی متنوع، از جمله دوره‌های کوتاه‌مدت فونتیک، تلفظ و مهارت شنیداری، توانسته است نیازهای مختلف زبان‌آموزان را پوشش دهد.',
              ),
              const SizedBox(height: 10),
              const IntroText(
                text:
                    'در سال ۱۴۰۳ نخستین دوره فارغ‌التحصیلی این آکادمی برگزار شد که نشان‌دهنده تعهد مستمر به آموزش مؤثر و باکیفیت است.',
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: getMediaQueryWidth(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'ما را در شبکه های اجتماعی دنبال کنید:',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: isThemeLight(context) ? kGreyColor800 : kGreyColor100,
                          ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            // await launchURL('https://www.facebook.com/share/19uwTL1suo/');
                          },
                          child: Image.asset(ImagesPaths.youtubeIconPng, height: 25),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () async {
                            // await launchURL('https://www.instagram.com/idea_afghan?igsh=dXNhcXZsaHFweDJn');
                          },
                          child: Image.asset(ImagesPaths.instagramIconPng, height: 25),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () async {
                            // await launchURL('https://www.facebook.com/share/1AxcZcUN93/');
                          },
                          child: Image.asset(ImagesPaths.facebookIconPng, height: 25),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () async {
                            // await launchURL('https://www.facebook.com/share/1AxcZcUN93/');
                          },
                          child: Image.asset(ImagesPaths.telegramIconPng, height: 25),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: () async {
                        var tawanaData = const ClipboardData(text: '@TawanaAcademy');
                        await Clipboard.setData(tawanaData);
                        if (await Clipboard.hasStrings()) {}
                        FlushbarPackage.showFlushbar(context, 'کپی شد');
                      },
                      child: Text(
                        '@TawanaAcademy',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: isThemeLight(context) ? kGreyColor800 : kGreyColor100,
                            ),
                        textDirection: TextDirection.ltr,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Container(
                width: getMediaQueryWidth(context, 0.6),
                height: 1,
                color: kGreyColor200,
              ),
              const SizedBox(height: 5),
              const LinksWidget(title: 'شماره های تماس:', value: '0792181090 - 0794491080'),
              const SizedBox(height: 5),
              const LinksWidget(title: 'ایمیل آدرس:', value: 'info@tawanaacademy.com'),
              const SizedBox(height: 5),
              const LinksWidget(title: 'آدرس وبسایت:', value: 'www.tawanaacademy.com'),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class LinksWidget extends StatelessWidget {
  const LinksWidget({super.key, required this.title, required this.value});
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getMediaQueryWidth(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: isThemeLight(context) ? kGreyColor800 : kGreyColor100,
                ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: isThemeLight(context) ? kGreyColor800 : kGreyColor100,
                ),
          ),
        ],
      ),
    );
  }
}

class IntroText extends StatelessWidget {
  const IntroText({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: isThemeLight(context) ? kGreyColor900 : kGreyColor100,
          ),
    );
  }
}

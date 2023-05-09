import 'package:flutter/material.dart';
import 'salah_steps.dart';

class SalahStepsProvider extends ChangeNotifier {
  final List<SalahSteps> _salahStepList = [
    SalahSteps(
        title: "Niyyah",
        stepNumber: "01",
        text:
            "Begin with the proper niyyah (intention) that you want to pray, this can be done in your mind or verbally. The purpose is so that you are not heedless in prayer but are aware of the kind of salat you are about to offer."),
    SalahSteps(
        title: "Takbeer",
        stepNumber: "02",
        text:
            "Stand as you would normally with your feet around four inches apart. Direct your gaze towards the place of your sajdah. Now, with palms open, raise your hands to your ears and say the Takbir (Allahu Akbar) which means Allah is the greatest. Women praying should raise their hands to their shoulders."),
    SalahSteps(
        title: "After-Takbeer",
        stepNumber: "03",
        text:
            "After Takbir, place cross your hands at chest level grabbing your left wrist with your right hand. Begin with the recitation of thana.\n\n سُبْحانَكَ اللَّهُمَّ وَبِحَمْدِكَ، وَتَبارَكَ اسْمُكَ، وَتَعَالَى جَدُّكَ، وَلاَ إِلَهَ غَيْرُكَ\n\n  Glory and praise be to You, O Allah. Blessed be Your name and exalted be Your majesty, there is none worthy of worship except You.\n\nRecite Tauz or Ta’awwudh and continue with saying bismillah\n\n  اعوذ باللہ من الشیطان الرجیم\n\n    بسم الله الرحمن الرحيم\n\nI seek Allah’s protection from Satan, the accursed. In the name of Allah who is kind and merciful."),
    SalahSteps(
        title: "Recitation",
        stepNumber: "04",
        text:
            "After this recite Surah Al-Fatiha which is the first chapter of the Quran\n\nاَلْحَمْدُ لِلّٰهِ رَبِّ الْعٰلَمِیْنَۙ(۱) الرَّحْمٰنِ الرَّحِیْمِۙ(۲) مٰلِكِ یَوْمِ الدِّیْنِؕ(۳) اِیَّاكَ نَعْبُدُ وَ اِیَّاكَ نَسْتَعِیْنُؕ(۴) اِهْدِنَا الصِّرَاطَ الْمُسْتَقِیْمَۙ(۵) صِرَاطَ الَّذِیْنَ اَنْعَمْتَ عَلَیْهِمْ غَیْرِ الْمَغْضُوْبِ عَلَیْهِمْ وَ لَا الضَّآلِّیْنَ۠\n\nPraise be to Allah, the Cherisher and Sustainer of the worlds; Most Gracious, Most Merciful; Master of the Day of Judgment. Thee do we worship, and Thine aid we seek. Show us the straight way, The way of those on whom Thou hast bestowed Thy Grace, those whose (portion) is not wrath, and who go not astray.\n\nAt the end of reciting Surah Fatiha say Ameen. After saying ameen, recite any passage from the Qur’an. Surah Ikhlas is commonly taught first because it is one of the shorter surahs and for the great rewards associated with it. For prayers which exceed two rakat, you only need to recite Surah Fatiha and can move onto step 5 without reciting any extra passage after fatiha."),
    SalahSteps(
        title: "Ruku",
        stepNumber: "05",
        text:
            "Say Allahu Akbar, bend down for ruku. Ruku is the position where you keep your head and back aligned and put your hands on your knees. Here recite Tasbeeh three times or any odd number of times you like\n\n.سُبْحَانَ رَبِّيَ الْعَظِيم ِ\n\nGlory be to my Lord Almighty"),
    SalahSteps(
        title: "Stand Up",
        stepNumber: "06",
        text:
            "Next stand up from the bowing position saying\n\nسَمِعَ اللَّهُ لِمَنْ حَمِدَه\n\nAllah hears those who praise Him"),
    SalahSteps(
        title: "Sajdah",
        stepNumber: "07",
        text:
            "Say Allahu Akbar and go down for sajdah (prostration). There should 5 points of contact with the ground, your forehead, nose, palms of hand, knees, and toes of the feet. Put your head between your palms such that your thumbs are aligned with earlobes. The elbows should be raised away from the ground. In this position recite Tasbeeh three or any odd number of times you like.\n\nسُبْحَانَ رَبِّيَ الأَعْلَى\n\n How Perfect is my Lord, the Highest"),
    SalahSteps(
        title: "Jalsah",
        stepNumber: "08",
        text:
            "Say Allahu Akbar, sit upright. It is sunnah to keep your right foot up and lay the left foot on the ground. This position is called Jalsah Al-istiraha or the sitting position of the prayer. Rest your hands on the thighs with fingers reaching the knees.\n\nSay Allahu Akbar and go for your second sujud, recite Subhana Rabbiyal A’la tasbeeh three times. After say Allahu Akbar and stand back up and cross your arms just as before. This represents one complete rakat of salah.\n\n Perform the second rakat the same, except you do not need to recite subhanaka. When you complete the second sujood of the second rakat stay seated in position of Jalsah."),
    SalahSteps(
        title: "Tash-hud",
        stepNumber: "09",
        text:
            "Here we recite Tashahhud silently\n\nالتَّحِيَّاتُ لِلَّهِ وَالصَّلَوَاتُ وَالطَّيِّبَاتُ، السَّلاَمُ عَلَيْكَ أَيُّهَا النَّبِيُّ وَرَحْمَةُ اللَّهِ وَبَرَكَاتُهُ، السَّلاَمُ عَلَيْنَا وَعَلَى عِبَادِ اللَّهِ الصَّالِحِينَ، أَشْهَدُ أَنْ لاَ إِلَهَ إِلاَّ اللَّهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ\n\nAll the best compliments and the prayers and the good things are for Allah. Peace and Allah’s Mercy and Blessings be on you, O Prophet! Peace be on us and on the pious slaves of Allah, I testify that none has the right to be worshipped but Allah, and I also testify that Muhammad is Allah’s slave and His Apostle.\n\nWhen you read the shahada (testimony of faith – ashhadu alla ilaha illallah wa ashhadu anna muhammadan abduhu wa rasuluhu) ball up your right hand into a fist and raise your index finger. This symbolizes the tawhid or oneness of Allah. At this point if the salat consists of more than two rakat you would say the takbir, i.e. Allahu akbar and begin the third rakat. If the salah only consists of two rakats then you would continue with the following supplication known as Salawat which is sends blessings and salutations towards the Prophet Muhammad and Prophet Ibrahim, may peace be upon them.\n\nاللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ كَمَا صَلَّيْتَ عَلَى آلِ إِبْرَاهِيمَ إِنَّكَ حَمِيدٌ مَجِيدٌ اللَّهُمَّ بَارِكْ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ كَمَا بَارَكْتَ عَلَى آلِ إِبْرَاهِيمَ إِنَّكَ حَمِيدٌ مَجِيدٌ\n\n O Allah, let Your mercy come upon Muhammad and the family of Muhammad as You let it come upon Ibrahim and the family of Ibrahim O Allah, bless Muhammad and the family of Muhammad as You blessed Ibrahim and the family of Ibrahim. Truly You are Praiseworthy and Glorious."),
    SalahSteps(
        title: "Salam",
        stepNumber: "10",
        text:
            "Turn your face towards looking over your right shoulder and then turn to left. Each time recite the following:\nالسَّلاَمُ عَلَيْكُمْ وَرَحْمَةُ اللهِ\n\nPeace and the mercy of Allah be on you\n\nThis would complete the two rakah salah. It is recommended to offer dua after salah, especially after fardh salah."),
  ];
  List<SalahSteps> get salahStepList => _salahStepList;
}

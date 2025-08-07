import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/audio.dart';
import 'therapist_choice_dialog.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> with TickerProviderStateMixin {
  bool _candleIsLit = true;
  bool _hasEarnedReward = false;
  String _displayText =
      'Swipe up to blow out the candle, \nand get 10 extra seconds!';

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  TherapistVoice? _selectedVoice;

  final String _calmingText =
      "You are in a safe environment. You are surrounded by your favourite people and your favourite things. You are calm. You feel warm and secure. All the overwhelming feelings you're experiencing will be released… as you breathe out.\nYou are safe. You are calm. Everything will be okay.";

  @override
  void initState() {
    super.initState();

    // Initialize fade animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    // Start with therapist selection
    _showTherapistChoice();
  }

  @override
  void dispose() {
    // Stop any playing audio when leaving the page
    Audio.stop();
    _fadeController.dispose();
    super.dispose();
  }

  void _showTherapistChoice() async {
    // Wait a moment for the page to load
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // Check if user has previously selected a voice
    final prefs = await SharedPreferences.getInstance();
    final savedVoice = prefs.getString('therapist_voice');

    if (savedVoice != null) {
      // Use saved preference
      _selectedVoice =
          savedVoice == 'male' ? TherapistVoice.male : TherapistVoice.female;
      _startCalmingExperience();
      return;
    }

    // Show selection dialog for first-time users
    final TherapistVoice? selectedVoice = await showDialog<TherapistVoice>(
      context: context,
      barrierDismissible: false, // User must make a choice
      builder: (BuildContext context) {
        return const TherapistChoiceDialog();
      },
    );

    if (selectedVoice != null) {
      _selectedVoice = selectedVoice;
      // Save user preference
      await prefs.setString('therapist_voice',
          selectedVoice == TherapistVoice.male ? 'male' : 'female');
      _startCalmingExperience();
    }
  }

  void _startCalmingExperience() async {
    // Start fade animation
    _fadeController.forward();

    // Play calming audio based on selected voice
    try {
      AudioType audioType = _selectedVoice == TherapistVoice.male
          ? AudioType.male_voice
          : AudioType.female_voice;
      await Audio.playAsset(audioType);
    } catch (e) {
      // Handle audio playback error silently
    }
  }

  void _changeTherapistVoice() async {
    final TherapistVoice? newVoice = await showDialog<TherapistVoice>(
      context: context,
      builder: (BuildContext context) {
        return const TherapistChoiceDialog();
      },
    );

    if (newVoice != null && newVoice != _selectedVoice) {
      setState(() {
        _selectedVoice = newVoice;
      });

      // Save new preference
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('therapist_voice',
          newVoice == TherapistVoice.male ? 'male' : 'female');

      // Play new voice sample
      try {
        AudioType audioType = _selectedVoice == TherapistVoice.male
            ? AudioType.male_voice
            : AudioType.female_voice;
        await Audio.playAsset(audioType);
      } catch (e) {
        // Handle audio playback error silently
      }
    }
  }

  void _onSwipeUp() {
    if (_candleIsLit && !_hasEarnedReward) {
      setState(() {
        _candleIsLit = false;
        _hasEarnedReward = true;
        _displayText = "You've earned 10 seconds!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(_hasEarnedReward ? 10 : 0);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent, // 设置Scaffold背景为透明
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () =>
                Navigator.of(context).pop(_hasEarnedReward ? 10 : 0),
          ),
          actions: [
            // Move settings button to AppBar actions
            IconButton(
              icon: const Icon(
                Icons.settings_voice,
                color: Colors.white,
                size: 30,
              ),
              onPressed: _changeTherapistVoice,
            ),
          ],
          backgroundColor: Colors.transparent, // AppBar也设为透明
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white), // 图标改为白色
        ),
        extendBodyBehindAppBar: true, // 让body延伸到AppBar后面
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background/help_background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Calming text with fade animation
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      _calmingText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'ICELAND',
                        fontSize: 40,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    _displayText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'ICELAND',
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      // 检测向上滑动手势 (dy < 0 表示向上)
                      if (details.delta.dy < -5) {
                        _onSwipeUp();
                      }
                    },
                    child: Center(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 50.0),
                          child: Image.asset(
                            _candleIsLit
                                ? 'assets/images/candle/candle_lit.jpg'
                                : 'assets/images/candle/candle_out.jpg',
                            fit: BoxFit.contain,
                            height: MediaQuery.of(context).size.height * 0.4,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

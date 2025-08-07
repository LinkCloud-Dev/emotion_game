import 'package:candycrush/pages/home_page.dart';
import 'package:flutter/material.dart';

class CheerPage extends StatefulWidget {
  const CheerPage({super.key});

  @override
  State<CheerPage> createState() => _CheerPageState();
}

class _CheerPageState extends State<CheerPage> {
  String? _selectedAnswer;

  final List<Map<String, String>> _options = [
    {'key': 'a', 'value': 'capable'},
    {'key': 'b', 'value': 'intelligent'},
    {'key': 'c', 'value': 'grounded'},
    {'key': 'd', 'value': 'resourceful'},
  ];

  void _selectAnswer(String answer) {
    setState(() {
      _selectedAnswer = answer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background/cheer_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Back button in top left corner
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      // Navigate back to home page, clearing all previous routes
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                        (route) => false,
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Title text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Fill in the blank to cheer yourself up!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'ICELAND',
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 60),

              // Question container with semi-transparent background
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 40.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color:
                          const Color(0x8013102F), // Semi-transparent #13102F
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Question text
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: const TextStyle(
                              fontFamily: 'ICELAND',
                              fontSize: 50,
                              color: Colors.white,
                              height: 1.5,
                            ),
                            children: [
                              const TextSpan(text: 'I trust that I am a '),
                              TextSpan(
                                text: '___',
                                style: TextStyle(
                                  color: Colors.yellow[300],
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              const TextSpan(
                                  text:
                                      ' person, and I allow myself to grow at my own pace.'),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Options
                        ..._options.map((option) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: GestureDetector(
                                onTap: () => _selectAnswer(option['value']!),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 24.0),
                                  decoration: BoxDecoration(
                                    color: _selectedAnswer == option['value']
                                        ? Colors.yellow[300]?.withOpacity(0.3)
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: _selectedAnswer == option['value']
                                          ? Colors.yellow[300]!
                                          : Colors.white.withOpacity(0.5),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${option['key']}. ${option['value']}',
                                    style: TextStyle(
                                      fontFamily: 'ICELAND',
                                      fontSize: 36,
                                      color: _selectedAnswer == option['value']
                                          ? Colors.yellow[300]
                                          : Colors.white,
                                      fontWeight:
                                          _selectedAnswer == option['value']
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            )),

                        const SizedBox(height: 40),

                        // Selected answer display
                        if (_selectedAnswer != null)
                          Container(
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              color: Colors.yellow[300]?.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.yellow[300]!,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              'I trust that I am a $_selectedAnswer person, and I allow myself to grow at my own pace.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'ICELAND',
                                fontSize: 40,
                                color: Colors.yellow[300],
                                fontWeight: FontWeight.bold,
                                height: 1.4,
                              ),
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
  }
}

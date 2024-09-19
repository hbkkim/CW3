import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;

  Timer? _hungerTimer; // Timer for increasing hunger
  Timer? _happinessTimer; // Timer for checking happiness
  int _happyDuration = 0; // Duration in seconds for tracking happiness over 80
  bool _hasWon = false; // Win condition
  bool _hasLost = false; // Loss condition

  @override
  void initState() {
    super.initState();
    _startHungerTimer(); // Start the hunger timer
    _startHappinessTimer(); // Start the happiness timer
  }

  @override
  void dispose() {
    _hungerTimer?.cancel(); // Cancel the hunger timer
    _happinessTimer?.cancel(); // Cancel the happiness timer
    super.dispose();
  }

  void _startHungerTimer() {
    _hungerTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      setState(() {
        hungerLevel += 10; // Increase hunger level by 10 every 30 seconds
        _checkLossCondition(); // Check for loss condition
      });
    });
  }

  void _startHappinessTimer() {
    _happinessTimer = Timer.periodic(Duration(seconds: 180), (timer) {
      if (happinessLevel > 80) {
        _happyDuration++;
      } else {
        _happyDuration = 0; // Reset duration if happiness is not above 80
      }

      if (_happyDuration >= 5) {
        setState(() {
          _hasWon = true; // Set win condition
        });
        _happinessTimer?.cancel(); // Stop checking for win condition
      }
    });
  }

  void _checkLossCondition() {
    if (happinessLevel <= 10 && hungerLevel >= 100) {
      setState(() {
        _hasLost = true; // Set loss condition
      });
      _hungerTimer?.cancel(); // Stop the hunger timer
      _happinessTimer?.cancel(); // Stop the happiness timer
    }
  }

  Color getHappinessColor(int happiness) {
    if (happiness > 70) {
      return Colors.green;
    } else if (happiness < 30) {
      return Colors.red;
    } else {
      return Colors.yellow;
    }
  }

  String getPetMood(int happiness) {
    if (happiness > 70) {
      return 'Happy 😊';
    } else if (happiness < 30) {
      return 'Unhappy 😢';
    } else {
      return 'Neutral 😐';
    }
  }

  // Function to increase happiness and update hunger when playing with the pet
  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      _updateHunger();
    });
  }

  // Function to decrease hunger and update happiness when feeding the pet
  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      _updateHappiness();
    });
  }

  // Update happiness based on hunger level
  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    } else {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
    }
  }

  // Increase hunger level slightly when playing with the pet
  void _updateHunger() {
    hungerLevel = (hungerLevel + 5).clamp(0, 100);
    if (hungerLevel > 100) {
      hungerLevel = 100;
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    }
  }

  @override
  Widget build(BuildContext context) {
    Color happinessColor = getHappinessColor(happinessLevel);
    String petMood = getPetMood(happinessLevel);

    if (_hasWon) {
      return _buildWinScreen();
    }

    if (_hasLost) {
      return _buildLossScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    petName = value; // Update pet name as user types
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Enter your pet\'s name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Text(
              'Name: $petName',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Happiness Level: $happinessLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Container(
              width: 100,
              height: 100,
              color: happinessColor,
            ),
            SizedBox(height: 16.0),
            Text(
              'Hunger Level: $hungerLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _playWithPet,
              child: Text('Play with Your Pet'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _feedPet,
              child: Text('Feed Your Pet'),
            ),
            Text(
              petMood,
              style: TextStyle(fontSize: 24),
            )
          ],
        ),
      ),
    );
  }
  Widget _buildWinScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text('You Win! 🎉'),
      ),
      body: Center(
        child: Text(
          'Congratulations! You kept your pet happy!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  Widget _buildLossScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text('You Lose! 😢'),
      ),
      body: Center(
        child: Text(
          'Your pet is too sad and hungry!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}




import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic Tac Toe',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo)
            .copyWith(secondary: Colors.indigo),
      ),
      home: const TicTacToe(),
    );
  }
}

class TicTacToe extends StatefulWidget {
  const TicTacToe({Key? key}) : super(key: key);

  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  var xTurn = false;
  int oScore = 0;
  int xScore = 0;
  var isGameOver = false;
  var gameState = 'O\'s turn';

  List<String?> currentValue = [
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null
  ];

  bool someoneWon() {
    if ((currentValue[0] != null &&
            currentValue[0] == currentValue[1] &&
            currentValue[1] == currentValue[2]) ||
        (currentValue[3] != null &&
            currentValue[3] == currentValue[4] &&
            currentValue[4] == currentValue[5]) ||
        (currentValue[6] != null &&
            currentValue[6] == currentValue[7] &&
            currentValue[7] == currentValue[8]) ||
        (currentValue[0] != null &&
            currentValue[0] == currentValue[3] &&
            currentValue[3] == currentValue[6]) ||
        (currentValue[1] != null &&
            currentValue[1] == currentValue[4] &&
            currentValue[4] == currentValue[7]) ||
        (currentValue[2] != null &&
            currentValue[2] == currentValue[5] &&
            currentValue[5] == currentValue[8]) ||
        (currentValue[0] != null &&
            currentValue[0] == currentValue[4] &&
            currentValue[4] == currentValue[8]) ||
        (currentValue[2] != null &&
            currentValue[2] == currentValue[4] &&
            currentValue[4] == currentValue[6])) {
      return true;
    } else {
      return false;
    }
  }


  bool isGameDraw() {
    if (!someoneWon() && !currentValue.contains(null)) {
      return true;
    } else {
      return false;
    }
  }

  void checkGameStatus() {
    if (isGameDraw()) {
      Vibration.vibrate(
        duration: 300,
        amplitude: 255,
      );

      setState(() {
        gameState = 'Game Draw';
      });
      return;
    }

    if (someoneWon()) {
      Vibration.vibrate(
        duration: 300,
        amplitude: 255,
      );
      setState(() {
        isGameOver = true;
        if (xTurn) {
          gameState = 'O won';
          oScore += 1;
          return;
        }
        if (!xTurn) {
          gameState = 'X won';
          xScore += 1;
          return;
        }
      });
    }
  }

  void changeValue(index) {
    if (currentValue[index] == null && isGameOver == false) {
      if (!xTurn) {
        setState(() {
          currentValue[index] = 'O';
          xTurn = true;
          gameState = 'X\'s turn';
        });
        checkGameStatus();
        return;
      }
      if (xTurn) {
        setState(() {
          currentValue[index] = 'X';
          xTurn = false;
          gameState = 'O\'s turn';
        });
        checkGameStatus();
        return;
      }
    }
  }

  void replayGame() {
    setState(() {
      currentValue = [null, null, null, null, null, null, null, null, null];
      isGameOver = false;
      gameState = xTurn ? 'X\'s turn' : 'O\'s turn';
    });
  }

  void resetGame() {
    setState(() {
      currentValue = [null, null, null, null, null, null, null, null, null];
      oScore = 0;
      xScore = 0;
      isGameOver = false;
      gameState = xTurn ? 'X\'s turn' : 'O\'s turn';
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    Widget _buildPlayGround() {
      return Container(
        padding: const EdgeInsets.all(10.0),
        height: isLandscape ? MediaQuery.of(context).size.height : 412,
        width: isLandscape
            ? MediaQuery.of(context).size.width / 2.9
            : double.infinity,
        child: GridView.builder(
          itemCount: 9,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: isLandscape ? 2.5 / 1.4 : 1,
            crossAxisCount: 3,
          ),
          itemBuilder: (ctx, i) => GestureDetector(
            key:ValueKey(DateTime.now()), 
            onTap: () {
              changeValue(i);
            },
            child: Container(
              child: Center(
                child: Text(
                  currentValue[i] ?? '',
                  style: TextStyle(
                    fontSize: isLandscape ? 80  : 100,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                border: Border.all(width: 1),
              ),
            ),
          ),
        ),
      );
    }

    Widget _buildGameInfo() {
      return Column(
        children: [
          Card(
            elevation: 9,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                gameState,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isLandscape)
                const SizedBox(
                  width: 15,
                ),
              Column(children: [
                const Text(
                  'O\'s Score',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                Text(
                  '$oScore',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                    color: Colors.indigo,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: replayGame,
                  icon: const Icon(Icons.replay, size: 30),
                  label: const Text(
                    'Replay',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ]),
              if (isLandscape)
                const SizedBox(
                  width: 50,
                ),
              Column(children: [
                const Text(
                  'X\'s Score',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                Text(
                  '$xScore',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                    color: Colors.indigo,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: resetGame,
                  icon: const Icon(Icons.restore_outlined, size: 30),
                  label: const Text(
                    'Reset',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ]),
              if (isLandscape)
                const SizedBox(
                  width: 15,
                ),
            ],
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        title: const Text(
          'Tic Tac Toe',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
      ),
      body: isLandscape
          ? Row(
              children: [
                Expanded(child: _buildPlayGround()),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: _buildGameInfo(),
                )
              ],
            )
          : Column(
              children: [
                _buildPlayGround(),
                _buildGameInfo(),
              ],
            ),
    );
  }
}

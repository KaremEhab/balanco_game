import re

with open('lib/game/game_area.dart', 'r') as f:
    content = f.read()

# 1. Imports
content = content.replace("import 'components/finish_line_component.dart';", "import 'components/teleporting_gate_component.dart';")

# 2. Variables
var_old = """  bool isCurtainDropping = false;
  bool isCurtainRetracting = false;
  bool isBoardHidden = false;

  bool isSpawningFromMap = true;
  double spawnTimer = 0.0;
  Vector2 spawnHolePos = Vector2.zero();
  HoleComponent? spawnHole;"""

var_new = """  bool isBoardHidden = false;
  final ValueNotifier<bool> showVictoryOverlay = ValueNotifier<bool>(false);
  bool isLevelCompleteOverlayShown = false;
  bool isSuckingToGate = false;

  bool isSpawningFromMap = true;
  double spawnTimer = 0.0;
  Vector2 spawnGatePos = Vector2.zero();
  TeleportingGateComponent? spawnGate;"""
content = content.replace(var_old, var_new)

comp_old = """  TeleporterComponent? activeExitTeleporter;
  late FinishLineComponent finishLineComponent;"""

comp_new = """  TeleporterComponent? activeExitTeleporter;
  TeleportingGateComponent teleportingGateComponent = TeleportingGateComponent()..priority = 5;"""
content = content.replace(comp_old, comp_new)

# 3. Methods
methods_old = """  Future<void> retractCurtainAndStartNextLevel() async {
    isCurtainDropping = false;
    isCurtainRetracting = true;
    finishLineComponent.targetHeight = 24.0;
    
    // Save progress!
    final prefs = await SharedPreferences.getInstance();
    
    int completedLevel = currentLevel.value;
    int starsEarned = currentPoints.value;
    
    // Save stars for THIS level (only overwrite if they got more stars)
    int previousStars = prefs.getInt('level_${completedLevel}_stars') ?? 0;
    if (starsEarned > previousStars) {
      await prefs.setInt('level_${completedLevel}_stars', starsEarned);
    }
    
    // Update highest level
    int highestLevel = prefs.getInt('highestLevel') ?? 1;
    if (completedLevel + 1 > highestLevel) {
      await prefs.setInt('highestLevel', completedLevel + 1);
    }

    currentLevel.value++;
  }

  void retractCurtainAndRestartLevel() {
    isCurtainDropping = false;
    isCurtainRetracting = true;
    // We don't advance the level, we just restart the current one after curtain goes up.
    // We'll set a flag so that `restartCurrentLevel` is called.
    finishLineComponent.targetHeight = 24.0;
    // By convention, if currentPoints was 0 it's a restart. We will just use startNextLevel = false;
  }"""

methods_new = """  Future<void> advanceToNextLevel() async {
    isSuckingToGate = false;
    showVictoryOverlay.value = false;
    isLevelCompleteOverlayShown = false;
    
    final prefs = await SharedPreferences.getInstance();
    int completedLevel = currentLevel.value;
    int starsEarned = currentPoints.value;
    int previousStars = prefs.getInt('level_${completedLevel}_stars') ?? 0;
    if (starsEarned > previousStars) {
      await prefs.setInt('level_${completedLevel}_stars', starsEarned);
    }
    int highestLevel = prefs.getInt('highestLevel') ?? 1;
    if (completedLevel + 1 > highestLevel) {
      await prefs.setInt('highestLevel', completedLevel + 1);
    }

    currentLevel.value++;
    restartCurrentLevel();
  }

  void restartLevelAfterWin() {
    isSuckingToGate = false;
    showVictoryOverlay.value = false;
    isLevelCompleteOverlayShown = false;
    restartCurrentLevel();
  }"""
content = content.replace(methods_old, methods_new)

# 4. _resetPositions
reset_old1 = """    isFreeFalling = false;
    isBoardHidden = false;
    timeStopTimer = 0.0;"""
reset_new1 = """    isFreeFalling = false;
    isBoardHidden = false;
    isLevelCompleteOverlayShown = false;
    teleportingGateComponent.reset();
    timeStopTimer = 0.0;"""
content = content.replace(reset_old1, reset_new1)

reset_old2 = """      if (isSpawningFromMap) {
        spawnHolePos = Vector2(size.x / 2.0, size.y * 0.15);
        if (spawnHole == null) {
          spawnHole = HoleComponent(Vector2(0.5, 0.15), 60.0, 0.0)..priority = 15;
          add(spawnHole!);
        }
        spawnHole!.scale = Vector2.all(1.0);
        ballPos2D = spawnHolePos.clone();
        ballScale = 0.0;
        spawnTimer = 1.5;"""
reset_new2 = """      if (isSpawningFromMap) {
        spawnGatePos = Vector2(size.x / 2.0, size.y * 0.15);
        if (spawnGate == null) {
          spawnGate = TeleportingGateComponent()..position = spawnGatePos..priority = 15;
          add(spawnGate!);
        }
        spawnGate!.position = spawnGatePos;
        spawnGate!.scale = Vector2.all(1.0);
        spawnGate!.reset();
        
        ballPos2D = spawnGatePos.clone();
        ballScale = 0.0;
        spawnTimer = 1.5;"""
content = content.replace(reset_old2, reset_new2)

# 5. onGameResize and onLoad
resize_old = """  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (leftY == 0.0 && rightY == 0.0) {
      _resetPositions();
    }
  }"""
resize_new = """  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (leftY == 0.0 && rightY == 0.0) {
      _resetPositions();
    }
    teleportingGateComponent.position = Vector2(size.x / 2.0, 70.0);
  }"""
content = content.replace(resize_old, resize_new)

load_old = """    ballComponent = BallComponent()..priority = 20;
    finishLineComponent = FinishLineComponent()..priority = 30;
    
    add(finishLineComponent); // Add flag above the ball and bar
    add(barComponent);"""
load_new = """    ballComponent = BallComponent()..priority = 20;
    
    add(teleportingGateComponent);
    add(barComponent);"""
content = content.replace(load_old, load_new)

# 6. Update physics
update_old = """    if (isCurtainRetracting) {
      if (finishLineComponent.currentHeight <= 25.0) {
        finishLineComponent.currentHeight = 24.0;
        isCurtainRetracting = false;
        isBoardHidden = false; // Show the board again!
        // Since we retracted, we reset the level now!
        restartCurrentLevel();
      }
      return; // Skip physics while retracting
    }

    if (isCurtainDropping) {
      // Hide the board items quickly as the curtain comes down
      if (finishLineComponent.currentHeight > 100.0) {
        isBoardHidden = true;
      }

      if (finishLineComponent.currentHeight >= size.y - 1.0) {
        finishLineComponent.currentHeight = size.y;
        // Don't pause engine, we need engine running for Flame tap events!
        // pauseEngine(); 
      }
      return; // Skip physics while dropping
    }

    // Check if reached Finish Line
    if (ballPos2D.y > 0 && ballPos2D.y < 25.0 && !isFalling) {
      HapticFeedback.heavyImpact();
      try {
        FlameAudio.play('win.wav', volume: 1.0);
      } catch (_) {}
      isCurtainDropping = true;
      finishLineComponent.targetHeight = size.y;

      // Spawn Confetti!
      final confetti = ConfettiComponent()
        ..size = size
        ..priority = 40;
      add(confetti);

      return;
    }"""
update_new = """    if (isSuckingToGate) {
      Vector2 gateCenter = teleportingGateComponent.position;

      // Move ball towards center
      double dx = gateCenter.x - ballPos2D.x;
      double dy = gateCenter.y - ballPos2D.y;
      
      // Suck ball into the center quickly
      ballPos2D.x += dx * dt * 5;
      ballPos2D.y += dy * dt * 5;
      
      // Jelly effect on the ball
      squashX = 0.5 + sin(teleportingGateComponent.isClosed ? 0 : 20) * 0.3;
      squashY = 1.5 + cos(teleportingGateComponent.isClosed ? 0 : 20) * 0.3;
      ballScale -= dt * 1.5; // shrink rapidly
      
      if (ballScale <= 0) {
        ballScale = 0;
        teleportingGateComponent.isClosing = true; // Tell the gate to close
        
        if (teleportingGateComponent.isClosed) { // wait for gate to close
          isBoardHidden = true;
          if (!isLevelCompleteOverlayShown) {
            isLevelCompleteOverlayShown = true;
            showVictoryOverlay.value = true;
            pauseEngine();
          }
        }
      }
      return; // Skip normal physics
    }

    // Check if reached top area to trigger gate snap
    if (!isFalling &&
        !isSpawningFromMap &&
        !isRespawningFromHole &&
        !isLevelCompleteOverlayShown) {
      Vector2 gateCenter = teleportingGateComponent.position;
      if (ballPos2D.distanceTo(gateCenter) < 40 || (ballPos2D.y < gateCenter.y + 10 && (ballPos2D.x - gateCenter.x).abs() < 50)) {
        isSuckingToGate = true;
        HapticFeedback.heavyImpact();
        try {
          FlameAudio.play('win.wav', volume: 1.0);
        } catch (_) {}
        return;
      }
    }"""
content = content.replace(update_old, update_new)

# 7. Update spawn physics
update_spawn_old = """    if (isSpawningFromMap) {
      spawnTimer -= dt;
      if (spawnTimer <= 0) {
        isSpawningFromMap = false;
        ballScale = 1.0;
        if (spawnHole != null) {
          spawnHole!.removeFromParent();
          spawnHole = null;
        }
        bounceTimer = 0.4; // Trigger bouncy landing!
        ballPos2D = leftPoint + direction * ballP + normal * (ballRadius + 6.0);
        HapticFeedback.heavyImpact();
        try { FlameAudio.play('tick.wav'); } catch (_) {}
      } else {
        double progress = 1.0 - (spawnTimer / 1.5);
        if (progress < 0.4) {
          double p = progress / 0.4;
          ballPos2D = spawnHolePos.clone();
          ballScale = p;
        } else {
          double p = (progress - 0.4) / 0.6;
          double curvedP = Curves.easeIn.transform(p);
          Vector2 targetPos = leftPoint + direction * ballP + normal * (ballRadius + 6.0);
          ballPos2D = spawnHolePos + (targetPos - spawnHolePos) * curvedP;
          ballScale = 1.0;
        }
      }
      return;
    }"""
update_spawn_new = """    if (isSpawningFromMap) {
      spawnTimer -= dt;
      if (spawnTimer <= 0) {
        isSpawningFromMap = false;
        isFreeFalling = true; // Fall to the bar!
        freeFallVelocity = Vector2(0, 0); // Straight down
        if (spawnGate != null) {
          spawnGate!.removeFromParent();
          spawnGate = null;
        }
      } else {
        if (spawnTimer > 1.0) {
           // Ball scaling up out of nothingness
           double t = (1.5 - spawnTimer) / 0.5; // 0 to 1
           ballScale = t;
           ballPos2D = spawnGatePos.clone();
        } else {
           ballScale = 1.0;
           ballPos2D = spawnGatePos.clone();
           // In freefall it will fall to the bar when spawn ends
        }
      }
      return;
    }"""
content = content.replace(update_spawn_old, update_spawn_new)

with open('lib/game/game_area.dart', 'w') as f:
    f.write(content)


class Screen {
  int fcStart, fcEnd, score;

  Screen() {
    gameScreen = 0;
    textAlign(CENTER);
  }

  //start screen
  void init() {
    background(0);
    fill(255);

    textSize(30);
    text("SPIELANLEITUNG", width / 2, height / 3);
    textSize(20);
    text("Bewege Rambe mit deiner Stimme nach oben", width / 2, height / 2 -60);
    text("Triff nicht die Wände", width / 2, height / 2 - 30);
    textSize(15);
    text("Bring Ramba mit deiner Stimme an den oberen Bidlschirmrand um zu beginnen.", width / 2, height / 2 + 90);

    player.update();
    player.show();
    if (player.y == 0) {
      gameScreen = 1;
      player = new Player();
      startScore();
    }
  }


  //playing surface
  void game() {
    background(0);

    player.hit();

    world.show();
    world.update();
    player.update();
    player.show();

    score = fcEnd - fcStart;
    textSize(16);
    fill(255, 0, 0);
    text("score: " + score, width / 2, 20);
  }


  //score screen
  void gameOver() {
    score = fcEnd - fcStart;
    
    if (score > highScore) {
      highScore = score;
    }


    background(0);

    textSize(60);
    fill(255, 0, 0);
    text("GAME OVER", width / 2, height / 3);
    textSize(40);
    text("YOUR SCORE: " + score, width / 2, height / 2);
    text("HIGHSCORE: " + highScore, width / 2, height / 2 + 50);
    text("HIT SPACE TO START AGAIN", width / 2, height / 2 + 150);

    player.update();
    player.show();
    if (player.y == 0) {
      gameScreen = 0;
      player = new Player();
      startScore();
    }
  }


  void startScore() {
    fcStart = frameCount;
  }


  void endScore() {
    fcEnd = frameCount;
  }


  //reset game
  void reset() {
    screen = new Screen();
    player = new Player();
    world = new World();

    background(0);
    gameScreen = 0;
  }
}
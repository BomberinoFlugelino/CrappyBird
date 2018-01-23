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
    text("CILCK TO STRAT", width / 2, height / 3);
    textSize(20);
    text("HOW TO PLAY", width / 2, height / 2);
    text("hit spacebar to move player", width / 2, height / 2 + 30);
    text("do not hit walls", width / 2, height / 2 + 60);
  }

  //playing surface
  void game() {
    background(0);

    player.hit();

    world.show();
    world.update();

    player.update();
    player.show();
  }

  //score screen
  void gameOver() {
    score = fcEnd - fcStart;
    //background(0);
    
    textSize(60);
    fill(255, 0, 0);
    text("GMAE OEVR", width / 2, height / 3);
    textSize(40);
    text("YOUR SCORE: " + score, width / 2, height / 2);
    text("CILCK TO STRAT AGAIN", width / 2, height / 2 + 50);
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
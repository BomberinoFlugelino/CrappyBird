
class Screen {
  int fcStart, fcEnd, score;

  Screen() {
    gameScreen = 0;
    textAlign(CENTER);
  }

  //start screen
  void init() {    
    background(0);

    stroke(255, 0, 0);
    strokeWeight(4);
    line(width/2, 0, width/2, height - 40);
    line(width/2, 0, width/2 + 30, 70);
    line(width/2, 0, width/2 - 30, 70);
    noStroke();

    fill(255);

    textSize(30);
    text("SPIELANLEITUNG", width / 2, 50);
    textSize(20);
    text("Bewege Rambe mit deiner Stimme nach oben", width / 2, 150);
    text("Triff nicht die Wände", width / 2, height / 2 - 30);
    textSize(15);
    text("Bring Ramba mit deiner Stimme an den oberen Bildschirmrand um zu beginnen.", width / 2, 250);

    player.update();
    player.show();
    if (player.y == 0) {
      input.close();
      input = minim.getLineIn(1);
      
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
    text("Punktzahl: " + score, width / 2, 20);

    if (sensitivity < maxSensitivity) {
      sensitivity += sensitivityIncrease;
    }
  }


  //score screen
  void gameOver() {
    score = fcEnd - fcStart;

    if (score > highScore) {
      highScore = score;
    }

    background(0);

    stroke(255, 0, 0);
    strokeWeight(4);
    line(width/2, 0, width/2, height - 40);
    line(width/2, 0, width/2 + 30, 70);
    line(width/2, 0, width/2 - 30, 70);
    noStroke();

    textSize(60);
    fill(255);
    text("GAME OVER", width / 2, 90);
    textSize(40);
    text("DEINE PUNKTZAHL: " + score, width / 2, 190);
    text("HIGHSCORE: " + highScore, width / 2, 250);
    textSize(15);
    text("Bring Ramba mit deiner Stimme an den oberen Bildschirmrand um zu beginnen.", width / 2, 350);


    player.update();
    player.show();
    if (player.y == 0) {
      gameScreen = 3;
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

    input.close();
    input = minim.getLineIn(1);

    background(0);
    gameScreen = 0;
    speed = 1;
  }
}

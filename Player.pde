class Player {
  float x, y;
  float gravity, velocity, lift;
  int diameter;
  PImage img;

  Player() {

    //start position of player 
    y = height / 2;
    x = width / 5 + 25;

    //size of player (used for world hit detection)
    diameter = height / 10 - 10;   

    gravity = 0.9;
    velocity = 0;
    lift = -1;

    imageMode(CENTER);
    img = loadImage("img/player.png");
    img.resize(0, height/10);
  }

  //show player at the beginning
  void show() {
    noFill();
    //fill(255, 0, 0);
    noStroke();
    //ellipse(x, y, diameter, diameter);
    image(img, x, y);
  }

  //update player (going down when no input)
  void update() {
    velocity += gravity;
    velocity *= 0.9;
    y += velocity;

    if (y > height) {
      y = height;
      velocity = 0;
    } else if (y < 0) {
      y = 0;
      velocity = 0;
    }
    screen.endScore();
  }

  //player goes up when spacebar is hit
  void up() {
    velocity += lift - 18;
  }

  void hit() {
    if (y - diameter / 2 <= world.yTop.get(1) || y + diameter / 2 >=  world.yBottom.get(1)) {
      gameScreen = 2;
      screen.endScore();
    }
  }
}
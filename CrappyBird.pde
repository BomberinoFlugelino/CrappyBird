//kein to do
/****** TO DO ******//*
 - make world more changing now it is always in the middle of screen the hole that shoul move
   - use noise
 - implement highscore
 - audio input
 - slider for auido sensitivity
 */

/****** OBJECTS ******/
Screen screen;
Player player;
World world;

/****** VARIABLES ******/
int gameScreen;
int highScore;

/****** SETUP ******/
void setup() {
  size(700, 850);

  screen = new Screen();
  player = new Player();
  world = new World();

  background(0);
}


/****** DRAW ******/
void draw() {
  if (gameScreen == 0) {
    //show start screen
    screen.init();
  } else if (gameScreen == 1) {
    //start game
    screen.game();
  } else if (gameScreen == 2) {
    //show game over screen
    screen.gameOver();
  } else if (gameScreen == 3) {
    //reset game
    screen.reset();
  }
}


/****** OTHER FUNCTIONS *****/
//start game
public void mousePressed() {
  if (gameScreen == 0 ) {
    gameScreen = 1;
    screen.startScore();
  } else if (gameScreen == 2 ) {
    gameScreen = 3;
  }
}  

//control player
void keyPressed() {
  if (key == ' ') {
    player.up();
  }
}
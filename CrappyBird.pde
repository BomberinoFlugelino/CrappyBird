/****** TO DO ******//*
 - make world more changing now it is always in the middle of screen the hole that shoul move
 - use noise
 - audio input
 - set slider value to 
 */

import controlP5.*;

/****** ControlP5 ******/
ControlP5 controlP5;
boolean showGUI = false;
Slider[] sliders;

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

  setupGUI();
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

//control player
void keyPressed() {
  if (key == ' ') {
    player.up();
    
    if (gameScreen == 0 ) {
      gameScreen = 1;
      screen.startScore();
    } else if (gameScreen == 2 ) {
      gameScreen = 3;
    }
  }
}
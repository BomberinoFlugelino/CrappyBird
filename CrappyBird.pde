/****** TO DO ******//*
 - make world more changing now it is always in the middle of screen the hole that shoul move
 - use noise
 - audio input
 - set slider value to 
 */

import processing.sound.*;
import ddf.minim.*;

/****** AUDIOINPUT ******/
Minim minim;
AudioInput input;

/****** OBJECTS ******/
Screen screen;
Player player;
World world;

/****** VARIABLES ******/
int gameScreen;
int highScore;
float vol, sensitivity;


/****** SETUP ******/
void settings(){
  fullScreen();
}

/****** SETUP ******/
void setup() {
  sensitivity = 20;

  screen = new Screen();
  player = new Player();
  world = new World();
  minim = new Minim(this);
  input = minim.getLineIn(1);

  background(0);
}


/****** DRAW ******/
void draw() {
  //save and calculate audio input (0-1)
  //formula (y=1-abs(x-1)^4)
  vol = 1 - pow(abs(input.mix.level() - 1), 4);
  vol = map(vol, 0, 1, 0, 100);

  if (gameScreen == 0) {
    player.x = width / 2;
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
      player = new Player();

    } else if (gameScreen == 2 ) {
      gameScreen = 3;
    }
  }
}
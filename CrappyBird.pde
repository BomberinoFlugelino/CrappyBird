/****** TO DO ******//*
 - make world more changing now it is always in the middle of screen the hole that shoul move
 - use noise
 - audio input
 - set slider value to 
 */

import processing.sound.*;

/****** AUDIOINPUT ******/
AudioIn mic;
Amplitude analyzer;

/****** OBJECTS ******/
Screen screen;
Player player;
World world;

/****** VARIABLES ******/
int gameScreen;
int highScore;
float vol, sensitivity;

/****** SETUP ******/
void setup() {
  size(700, 850);
  
  sensitivity = 10;

  screen = new Screen();
  player = new Player();
  world = new World();
    
  mic = new AudioIn(this, 0);
  mic.start();
  analyzer = new Amplitude(this);
  analyzer.input(mic);

  background(0);

}


/****** DRAW ******/
void draw() {
  //save and calculate audio input (0-1)
  //formula (y=1-abs(x-1)^4)
  vol = 1 - pow(abs(analyzer.analyze() - 1), 4);
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
    } else if (gameScreen == 2 ) {
      gameScreen = 3;
    }
  }
}
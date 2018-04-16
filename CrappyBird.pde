/***** RASPBERRY SETTINGS *****/
/* change .txt file
 terminal > ssh -y pi@IP-ADRESS
 sudo nano /boot/config.txt
 decomment line hdmi_safe=1 and hdmi_force_hotplug=1
 */

/****** TO DO ******//*
 - make world more changing now it is always in the middle of screen the hole that should move
 - use noise for world
 */

import processing.sound.*;
import ddf.minim.*;
import oscP5.*;
import netP5.*;

/****** OSC ******/
OscP5 osc;
NetAddress oscIN;
NetAddress oscOUT;

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
float speed, speedInc;

///****** OSC ******
//me as transmitter
String IPOut = "192.168.0.18";
int portOut = 10400;
//the other as receiver
//String IPIn = "192.168.0.19"; 
int portIn = 5007;
float oscVol;

/****** SETTINGS ******/
void settings() {
  //fullScreen();
  size(400, 800);
}

/****** SETUP ******/
void setup() {
  sensitivity = 20;

  screen = new Screen();
  player = new Player();
  world = new World();
  minim = new Minim(this);
  input = minim.getLineIn(1);

  //start oscP5, listening for incoming messages at port portReceiv
  osc = new OscP5(this, portIn);
  //oscIN = new NetAddress(IPIn, portIn);
  oscOUT = new NetAddress(IPOut, portOut);

  background(0);
}

/****** DRAW ******/
void draw() {
  //save and calculate audio input (0-1)
  //formula (y=1-abs(x-1)^4)
  vol = 1 - pow(abs(input.mix.level() - 1), 4);
  oscVol = vol; //save vol for osc message
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

/****** OSC Sender *****/

void OSC_sender() {
  OscMessage messageTransmit = new OscMessage("CrappyBird");
  messageTransmit.add(oscVol);
  messageTransmit.add(screen.score);
  messageTransmit.add(highScore);

  osc.send(messageTransmit, oscOUT);

  println(messageTransmit);
}

/***** RASPBERRY SETTINGS *****
 -> for using the miniTV
 change .txt file
 terminal > ssh -y pi@IP-ADRESS
 sudo nano /boot/config.txt
 uncomment line hdmi_safe=1 and hdmi_force_hotplug=1
 */

/****** TO DO ******
 - make world more changing
 - use noise for world
 */

import ddf.minim.*;
import oscP5.*;
import netP5.*;

/****** OSC ******/
OscP5 osc;
NetAddress oscIN;
NetAddress[] oscOUT = new NetAddress[3]; //make oscOUT objects for all IPs

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

//****** OSC ******
String[] IPsOut = {"192.168.0.18", "192.168.0.19", "192.168.0.18"}; //ip where message is send to
int portsOut[] = {10400, 10400, 10400}; //port on which message will be send
int portIn = 5007; //port on whicht it will listen for messages
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

  //start oscP5, listening for incoming messages at portIn
  osc = new OscP5(this, portIn);

  //create oscOUT objects for all IPs
  for (int i=0; i < IPsOut.length; i++) {
    oscOUT[i] = new NetAddress(IPsOut[i], portsOut[i]);
  }

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
    player.x = width / 2;
    //show game over screen
    screen.gameOver();
    //set world-speed to default
    speed = 1;
    speedInc = 0.01;
  } else if (gameScreen == 3) {
    //reset game
    screen.reset();
  }
}

/****** OSC Sender *****/
void OSC_sender() {
  //create message
  OscMessage messageTransmit = new OscMessage("/CrappyBird");
  messageTransmit.add(oscVol);
  messageTransmit.add(screen.score);
  messageTransmit.add(highScore);
  messageTransmit.add(gameScreen);

  //send to all IPs
  for (int i=0; i < IPsOut.length; i++) {
    osc.send(messageTransmit, oscOUT[i]);
    //println(IPsOut[i], portsOut[i]);
  }
  //println(messageTransmit);
}

/****** OTHER FUNCTIONS *****/
//--- control player ---
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

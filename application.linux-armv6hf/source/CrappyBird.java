import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 
import oscP5.*; 
import netP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class CrappyBird extends PApplet {

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
public void settings() {
  //fullScreen();
  size(600, 400); //size on little TV
}

/****** SETUP ******/
public void setup() {
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
public void draw() {  
  //save and calculate audio input (0-1)
  //formula (y=1-abs(x-1)^4)
  vol = 1 - pow(abs(input.mix.level() - 1), 4);
  oscVol = vol; //save vol for osc message
  vol = map(vol, 0, 1, 0, 100);

  OSC_sender();

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
    speedInc = 0.01f;
  } else if (gameScreen == 3) {
    //reset game
    screen.reset();
  }
}

/****** OSC Sender *****/
public void OSC_sender() {
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
public void keyPressed() {
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

    gravity = 0.4f;
    velocity = 0;
    lift = -1;

    imageMode(CENTER);
    img = loadImage("img/player.png");
    img.resize(0, height/10);
  }

  //show player at the beginning
  public void show() {
    noFill();
    //fill(255, 0, 0);
    noStroke();
    //ellipse(x, y, diameter, diameter);
    image(img, x, y);
  }
  

  //update player (going down when no input)
  public void update() {
    velocity += gravity;
    velocity *= 0.9f;
    y += velocity;


    if (y > height) {
      y = height;
      velocity = 0;
    } else if (y < 0) {
      y = 0;
      velocity = 0;
    }
    
    if(gameScreen == 1){
      screen.endScore();
    }

    if (vol > sensitivity) {
      up();
    }
  }


  //player goes up with audioinput
  public void up() {
    velocity += lift;
  }


  public void hit() {
    if (y - diameter / 2 <= world.yTop.get(1) || y + diameter / 2 >=  world.yBottom.get(1)) {
      gameScreen = 2;
      screen.endScore();
    }
  }
}

class Screen {
  int fcStart, fcEnd, score;

  Screen() {
    gameScreen = 0;
    textAlign(CENTER);
  }

  //start screen
  public void init() {
    background(0);
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
      gameScreen = 1;
      player = new Player();
      startScore();
    }
  }


  //playing surface
  public void game() {
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
  }


  //score screen
  public void gameOver() {
    score = fcEnd - fcStart;

    if (score > highScore) {
      highScore = score;
    }

    background(0);

    textSize(60);
    fill(255, 0, 0);
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


  public void startScore() {
    fcStart = frameCount;
  }


  public void endScore() {
    fcEnd = frameCount;
  }


  //reset game
  public void reset() {
    screen = new Screen();
    player = new Player();
    world = new World();

    
    
    background(0);
    gameScreen = 0;
    speed = 1;

  }
}
class World {
  int detail;
  float rectWidth;
  FloatList xPos, yTop, yBottom;
  int yMin, yMax;
  float y1, yOff = 0, y2;

  float space;

  int worldColor;

  World() {
    //how many rect
    detail = 4; 
    rectWidth = width / detail;

    //list for saving coordinates
    xPos = new FloatList();
    yTop = new FloatList();
    yBottom = new FloatList();

    //minimum height of rect
    yMin = 20;
    yMax = height / 2 - 100;

    //space between top and bottom rect
    space = height / 2;

    speed = 1;
    speedInc = 0.01f;
    worldColor = color(0, 255, 0);

    rectMode(CORNERS);

    for (int i = 0; i < detail + 2; i++) { //+2 is for start and end
      xPos.append(i * rectWidth);
      yTop.append(random(yMin, yMax));
      yBottom.append(random(height - yMax, height - yMin));
    }
    //y1 = yTop.get(yTop.size()-1);
    xPos.set(5, width);
  }

  public void show() {
    stroke(worldColor);
    fill(worldColor);
    for (int i = 0; i < xPos.size() - 1; i++) {
      rect(xPos.get(i), 0, xPos.get(i + 1), yTop.get(i));
      rect(xPos.get(i), yBottom.get(i), xPos.get(i + 1), height);
      //      rect(xPos.get(i), height - yBottom.get(i), xPos.get(i + 1), height);
    }
  }


  public void update() {
    //calculate new position
    for (int i = 0; i < xPos.size(); i++) {
      //move all xPos with speed to the left
      xPos.sub(i, speed);
      //set first and last xPos to 0 and width
      xPos.set(0, 0);
      xPos.set(5, width);

      //check if first rect is disappearing
      if ( xPos.get(1) < 0) {

        //calculate new height of last rect
        yTop.remove(0);
        //yTop.append(random(yMin, yMax));
        yBottom.remove(0);
        //yBottom.append(yTop.get(5));

        yOff = yOff + 5;
        y1 = noise(yOff) * (height - space - 20);
        //y1 = map(y1, 0, 1, 20, height - space - 20);
        //y1 = random(20, height - space - 20);
        y2 = y1 + space;
        yTop.append(y1);
        yBottom.append(y2);


        //set xPos to startvalues
        for (int j = 1; j < xPos.size() - 1; j++) {
          xPos.set(j, j * rectWidth);
        }
      }
    }
    speed += speedInc;
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#1E1E1E", "--hide-stop", "CrappyBird" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

class World {
  int detail;
  float rectWidth;
  FloatList xPos, yTop, yBottom;
  int yMin, yMax;
  float y1, y2;

  float space;
  float speed, speedInc;

  color worldColor;

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
    space = 300;

    speed = 0.5;
    speedInc = 0.01;
    worldColor = color(0, 255, 0);

    rectMode(CORNERS);

    for (int i = 0; i < detail + 2; i++) { //+2 is for start and end
      xPos.append(i * rectWidth);
      yTop.append(random(20, 200));
      yBottom.append(random(height - 200, height - 20));
    }
    xPos.set(5, width);
  }

  void show() {
    stroke(worldColor);
    fill(worldColor);
    for (int i = 0; i < xPos.size() - 1; i++) {
      rect(xPos.get(i), 0, xPos.get(i + 1), yTop.get(i));
      rect(xPos.get(i), yBottom.get(i), xPos.get(i + 1), height);
      //      rect(xPos.get(i), height - yBottom.get(i), xPos.get(i + 1), height);
    }
  }


  void update() {
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

        y1 = random(20, height - space - 20);
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
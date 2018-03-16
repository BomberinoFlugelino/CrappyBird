int x = 0;
FloatList y;
float noiseScale = 0.009;
float i = 0.0;
float wallThikness = 20.0;
float space;
float detail = 150;

//todo
//noise wall shoul be between 20 and height-20
void setup() {
  size(400, 400);
  space = 250;
  
  y = new FloatList();

}

void draw() {
  background(0);
  for (int x=0; x < width; x++) {
    float noiseVal = noise((i+x)*noiseScale, noiseScale);
    i = i + 0.008;

    stroke(0, 255, 0);

    //save value between 0 - 200
    y.append(height/2 +100 - noiseVal * detail);

    //should be between 0 + space + 10 and height - space - 10

    //y = map(y, 0, 200, space + 10, height - space - 10);

    line(x, y.get(x) + (space / 2), x, height);
    line(x, y.get(x) - (space / 2), x, 0);


    //y2 = (height - y1);
    //line(x, y2, x, 0);
    
  }
}
int x = 0, y;
float noiseScale = 0.008;
float i = 0.0;
float wallThikness = 20.0;
float space = height - 2 * wallThikness;


void setup() {
  size(400, 400);
}

void draw() {
  background(0);
  for (int x=0; x < width; x++) {
    float noiseVal = noise((i+x)*noiseScale, noiseScale);
    i = i + 0.005;
    stroke(0, 255, 0);
    line(x, height - wallThikness - noiseVal * 80, x, height);
    
    
    
    line(x, height - wallThikness - noiseVal * 80 - space, x, 0);
  }
}
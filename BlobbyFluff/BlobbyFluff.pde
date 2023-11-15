PShader edges;
PImage img;
Fluff fluff;

float timeStep = 0.01;

void setup() {
  size(640, 640, P2D);
  rectMode(CENTER);
  fluff = new Fluff(
    width/2.0,
    height/2.0,
    200
  );
}

void draw() {
  drawBackground();
  fluff.update();
}

void drawBackground() {
  background(250);
}

float timeStep = 0.001;
float time = 0.0;
float numberOfColumns= 15;
float cellSize;
float cellRadius;
float dotRadius;

float minDotRadius;
float maxDotRadius;

PShader superShader;


boolean changeColor = true;
boolean overTime = true;

void setup() {
  size(640, 640, P2D);
  colorMode(HSB, 360, 1.0, 1.0);
  cellSize = width/numberOfColumns;
  cellRadius = cellSize/2;
  dotRadius = cellSize/5;
  minDotRadius = dotRadius * 0.6f;
  maxDotRadius = dotRadius * 1.6f;
  
  superShader = loadShader("nstvFractal.glsl");
  superShader.set("iResolution", float(width), float(height), float(0));
}

void draw() {
  drawBackground();
  fill(200, 0, 0);
  //drawGrid(time);
  //drawGridWithGuidelines(time);
  //drawRandomSizeGrid(time);
  //drawSimpleSizeGrid(time);
  //drawSimpleSizeGridWithoutNorm(time);
  //drawFullGrid(time);
  //drawFullGridNoise(time);
  drawGridShader(time);
  time += timeStep;
}

void drawGridWithGuidelines(float time) {
  rectMode(CENTER);
  for (int x = 0; x<numberOfColumns; x++) {
    for (int y = 0; y<numberOfColumns; y++) {

      float posX = x*cellSize + cellSize/2;
      float posY = y*cellSize + cellSize/2;


      fill(0);
      circle(posX, posY, dotRadius*2);
      noFill();
      rect(posX, posY, cellSize, cellSize);
    }
  }
}


void drawGrid(float time) {
  for (int x = 0; x<numberOfColumns; x++) {
    for (int y = 0; y<numberOfColumns; y++) {

      float posX = x*cellSize + cellSize/2;
      float posY = y*cellSize + cellSize/2;

      circle(posX, posY, dotRadius*2);
    }
  }
}

void drawRandomSizeGrid(float time) {
  //randomSeed(int(time*1000));
  for (int x = 0; x<numberOfColumns; x++) {
    for (int y = 0; y<numberOfColumns; y++) {

      float posX = x*cellSize + cellRadius;
      float posY = y*cellSize + cellRadius;


      float newDotRadius = random(minDotRadius, maxDotRadius);

      float hue = map(
        newDotRadius,
        minDotRadius,
        maxDotRadius,
        200, 300
        );

      if (changeColor) {
        fill(hue, 0.4, 1); // HSB
      }
      circle(posX, posY, newDotRadius*2);

      if (!overTime) {
        noLoop();
      }
    }
  }
  // Slow random framerate
  delay(50);
}

void drawSimpleSizeGrid(float time) {
  for (int x = 0; x<numberOfColumns; x++) {
    for (int y = 0; y<numberOfColumns; y++) {

      float posX = x*cellSize + cellRadius;
      float posY = y*cellSize + cellRadius;

      // Normalize values to U/V (0-1)
      float u = posX/width;
      float v = posY/height;

      float newDotRadius = map(
        sin(u*TWO_PI),
        -1, 1,
        minDotRadius, maxDotRadius
        );

      float hue = map(
        newDotRadius,
        minDotRadius,
        maxDotRadius,
        200, 300
        );

      if (changeColor) {
        fill(hue, 0.4, 1); // HSB
      }
      circle(posX, posY, newDotRadius*2);

      if (!overTime) {
        noLoop();
      }
    }
  }
}

void drawSimpleSizeGridWithoutNorm(float time) {
  for (int x = 0; x<numberOfColumns; x++) {
    for (int y = 0; y<numberOfColumns; y++) {

      float posX = x*cellSize + cellRadius;
      float posY = y*cellSize + cellRadius;

      float newDotRadius = map(
        sin(posX),
        -1, 1,
        minDotRadius, maxDotRadius
        );

      float hue = map(
        newDotRadius,
        minDotRadius,
        maxDotRadius,
        200, 300
        );

      if (changeColor) {
        fill(hue, 0.4, 1); // HSB
      }
      circle(posX, posY, newDotRadius*2);

      if (!overTime) {
        noLoop();
      }
    }
  }
}

void drawFullGrid(float time) {
  for (int x = 0; x<numberOfColumns; x++) {
    for (int y = 0; y<numberOfColumns; y++) {

      float posX = x*cellSize + cellRadius;
      float posY = y*cellSize + cellRadius;

      // Normalize values to U/V (0-1)
      float u = posX/width;
      float v = posY/height;


      float newDotRadius = map(
        sin(u*TWO_PI+time*20) + cos(v*TWO_PI + time*20),
        -2, 2,
        minDotRadius, maxDotRadius
        );

      float hue = map(
        newDotRadius,
        minDotRadius,
        maxDotRadius,
        200, 300
        );

      if (changeColor) {
        fill(hue, 0.4, 1); // HSB
      }
      circle(posX, posY, newDotRadius*2);

      if (!overTime) {
        noLoop();
      }
    }
  }
}

void drawFullGridNoise(float time) {
  for (int x = 0; x<numberOfColumns; x++) {
    for (int y = 0; y<numberOfColumns; y++) {

      float posX = x*cellSize + cellRadius;
      float posY = y*cellSize + cellRadius;

      // Normalize values to U/V (0-1)
      float u = posX/width;
      float v = posY/height;


      float newDotRadius = map(
        noise(u, v, time *20),
        0, 1,
        minDotRadius, maxDotRadius
        );

      float hue = map(
        newDotRadius,
        minDotRadius,
        maxDotRadius,
        200, 300
        );

      if (changeColor) {
        fill(hue, 0.4, 1); // HSB
      }
      circle(posX, posY, newDotRadius*2);

      if (!overTime) {
        noLoop();
      }
    }
  }
}

void drawGridShader(float time) {
  minDotRadius = dotRadius;
  maxDotRadius = cellSize*0.7;
  superShader.set("iTime", millis() / 1000.0);
  shader(superShader);
  drawFullGrid(time);
}

void drawBackground() {
  background(#ffffff);
}

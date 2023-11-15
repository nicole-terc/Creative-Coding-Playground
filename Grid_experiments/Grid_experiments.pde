float timeStep = 0.001;
float zOff = 0.0;
float  numberOfColumns= 10;
float cellSize;
float cellRadius;
float dotRadius;

float minDotSize;
float maxDotSize;

float shiftDiff = 5;

boolean changeColor = false;
boolean changeSize = true;
boolean shiftedCoords = false;
boolean overTime = false;

void setup() {
  size(640, 640, P2D);
  colorMode(HSB, 360, 1.0, 1.0);
  cellSize = width/numberOfColumns;
  cellRadius = cellSize/2;
  dotRadius = cellSize/5;
  minDotSize = dotRadius * 0.6f;
  maxDotSize = dotRadius * 1.6f;
}

void draw() {
  drawBackground();
  fill(200, 0, 0);

  for (int x = 0; x<numberOfColumns; x++) {
    for (int y = 0; y<numberOfColumns; y++) {
      //rect(x, y, cellSize, cellSize);

      // Normalize values to U/V (0-1)
      float u = cellSize*x/width;
      float v = cellSize*y/height;

      float posX = x*cellSize + cellRadius;
      float posY = y*cellSize + cellRadius;

      float newDotRadius = map(
        sin((u*TWO_PI+zOff*20)), //+ cos((v*TWO_PI + zOff*20)),
        -1, 1,
        minDotSize, maxDotSize
        );


      float shiftedX = posX + map(
        sin(u*TWO_PI +zOff*20),
        -1, 1,
        -shiftDiff, shiftDiff
        );

      float shiftedY = posY + map(
        cos(v*TWO_PI + zOff*20),
        -1, 1,
        -shiftDiff, shiftDiff
        );

      float hue = map(
        newDotRadius,
        minDotSize,
        maxDotSize,
        200, 300
        );

      if (changeColor) {
        fill(hue, 0.4, 1);
      }
      if (changeSize && shiftedCoords) {
        circle(shiftedX, shiftedY, newDotRadius*2);
      } else if (changeSize) {
        circle(posX, posY, newDotRadius*2);
      } else {
        circle(posX, posY, dotRadius*2);
      }

      if (!overTime) {
        noLoop();
      }
    }
  }

  zOff += timeStep;
}

void drawBackground() {
  background(#ffffff);
}

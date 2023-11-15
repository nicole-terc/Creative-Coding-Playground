PShader superShader;

float timeStep = 0.001;
float zOff = 0.0;
float  numberOfColumns= 10;
float numberOfPoints = 25;
float minNumberOfPoints = 10;
float maxNumberOfPoints = 300;
float cellSize;
float cellRadius;
float dotRadius;
float centerX;
float centerY;

float minDotSize;
float maxDotSize;

float shiftDiff = 5;

boolean changeColor = true;
boolean changeSize = true;
boolean shiftedCoords = false;
boolean spin = false;
boolean showText = false;

boolean useShader = true;
boolean overTime = true;

final int ARCHIMEDEAN = 0;
final int LOGARITHMIC = 1;
final int LOGARITHMIC_TUNNEL = 2;
final int PHYLLOTAXIS = 3;

int selectedSpiral = ARCHIMEDEAN;

float[] getAngleAndRadius(int index) {
  float pointSeparation;
  float angle;
  float radius;

  switch(selectedSpiral) {
  case PHYLLOTAXIS:
    pointSeparation = 30.0;
    angle = radians(index * 137.5);
    radius = pointSeparation * sqrt(float(index));
    break;
  case LOGARITHMIC:
    pointSeparation = 30.0;
    angle = radians(index * pointSeparation);
    radius = (pointSeparation/3) * exp(angle/(pointSeparation/4));
    break;
  case LOGARITHMIC_TUNNEL:
    pointSeparation = 30.0;
    angle = radians(index * pointSeparation);
    radius = (pointSeparation) * exp(angle/(pointSeparation));
    break;
  case ARCHIMEDEAN:
  default:
    pointSeparation = 20.0;
    angle = radians(index * pointSeparation);
    radius = angle * pointSeparation;
    break;
  }
  float[] values = {angle, radius};
  return values;
}

String getCurrentSpiralTypeName() {
  String name;
  switch(selectedSpiral) {
  case PHYLLOTAXIS:
    name = "PHYLLOTAXIS";
    break;
  case LOGARITHMIC:
    name = "LOGARITHMIC";
    break;
  case LOGARITHMIC_TUNNEL:
    name = "LOGARITHMIC_TUNNEL";
    break;
  case ARCHIMEDEAN:
  default:
    name = "ARCHIMEDEAN";
    break;
  }
  return name;
}


void setup() {
  size(640, 640, P2D);
  textSize(16);
  colorMode(HSB, 360, 1.0, 1.0);
  cellSize = width/numberOfColumns;
  cellRadius = cellSize/2;
  dotRadius = cellSize/6;
  minDotSize = dotRadius * 0.6f;
  maxDotSize = dotRadius * 1.6f;
  centerX = width/2;
  centerY = height/2;
  if (useShader) {
    superShader = loadShader("nstvFractal.glsl");
    superShader.set("iResolution", float(width), float(height), float(0));
  }
}

void draw() {
  drawBackground();
  fill(200, 0, 0);

  for (int index = 0; index<numberOfPoints; index++) {

    float[] angleRadius = getAngleAndRadius(index);
    float angle = angleRadius[0];
    float radius = angleRadius[1];

    if (spin) {
      angle = angle + zOff;
    }

    float posX = radius * cos(angle) + centerX;
    float posY = radius * sin(angle) + centerY;

    // Normalize values to U/V (0-1)
    float u = posX/width;
    float v = posY/height;

    float newDotRadius = map(
      noise(radius, zOff *20),
      0, 1,
      radius/8*0.6, radius/8*1.6
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

    if (useShader) {
      superShader.set("iTime", millis() / 1000.0);
      shader(superShader);
    } else {
      float hue = //degrees(angle + zOff)%360;
        map( degrees(angle)%360,
        0,
        360,
        200, 300
        );

      if (changeColor) {
        fill(hue, 0.4, 1);
      }
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

  zOff += timeStep;

  if (showText) {
    fill(200, 0, 0);
    text("Spiral Type: " + getCurrentSpiralTypeName(), 8, height -20);
  }
}

void drawBackground() {
  background(#ffffff);
}

void mousePressed() {
  if (selectedSpiral == PHYLLOTAXIS ) {
    selectedSpiral = 0;
  } else {
    selectedSpiral++;
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  numberOfPoints += (minNumberOfPoints * e/10);
  if (numberOfPoints > maxNumberOfPoints) {
    numberOfPoints = maxNumberOfPoints;
  } else if (numberOfPoints < minNumberOfPoints) {
    numberOfPoints=minNumberOfPoints;
  }
  println(e);
}

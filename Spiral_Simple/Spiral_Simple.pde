float timeStep = 0.005;
float time = 0.0;

float numberOfPoints = 40;
float minNumberOfPoints = 5;
float maxNumberOfPoints = 300;
float dotRadius;
float centerX;
float centerY;

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
  dotRadius = 10.0;
  centerX = width/2;
  centerY = height/2;
}

void draw() {
  drawBackground();

  for (int index = 0; index<numberOfPoints; index++) {

    float[] angleRadius = getAngleAndRadius(index);
    float angle = angleRadius[0];
    float radius = angleRadius[1];

    float posX = radius * cos(angle + time) + centerX;
    float posY = radius * sin(angle + time) + centerY;

    float newDotRadius = radius/8.0;

    float hue = degrees(angle + time)%360;
    fill(hue, 0.5, 1.0);
    circle(posX, posY, newDotRadius*2);
  }

  time += timeStep;

  fill(200, 0, 0);
  text("Spiral Type: " + getCurrentSpiralTypeName(), 8, height -20);
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

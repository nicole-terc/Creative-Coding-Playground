float angleStep = 0.01;
float radiusDiff = 40;

class Fluff {
  float minRadius;
  float maxRadius;
  float radius;
  float centerX;
  float centerY;
  PVector center;
  ArrayList<PVector> fluffPoints = new ArrayList();
  float zOff;


  Fluff(float x, float y, float radius) {
    this.centerX = x;
    this.centerY = y;
    this.radius = radius;
    this.center = new PVector(centerX, centerY);
    assembleFluffPoints();
    zOff = 0.0;
}

  void update() {
    assembleFluffPoints();
    zOff += timeStep;
  }

  void assembleFluffPoints() {

    fill(#000000,50);
    circle(centerX, centerY, radius*2);
    
    fluffPoints.clear();
    float currentAngle = 0.0;

    fill(#8287D3,90);
    beginShape();
    while (currentAngle <= TWO_PI) {
      float xOff = cos(currentAngle/8)*8;
      float yOff = sin(currentAngle/8)*8;

      float noise = map(noise(xOff, yOff, zOff),0,1,-1,1);
      float pointRadius =  radius + radiusDiff*noise;
      PVector point = new PVector(
        pointRadius * cos(currentAngle),
        pointRadius * sin(currentAngle)
        ).add(center);


      fluffPoints.add(point);
      vertex(point.x, point.y);

      currentAngle += angleStep;
    }
    endShape();
  }
}

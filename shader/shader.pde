PShader myShader;

void setup() {
  size(640, 640, P2D);
  noStroke();

  myShader = loadShader("nstvFractal.glsl");
  myShader.set("iResolution", float(width), float(height), float(0));
}

void draw() {
  myShader.set("iTime", millis() / 1000.0);  
  shader(myShader); 
  rect(0, 0, width, height);
}

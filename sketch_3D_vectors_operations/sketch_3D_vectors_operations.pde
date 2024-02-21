void setup() {
  size(1280, 720, P3D);
}

void draw() {
  basicSetUp();
  vectorSubstraction(200, 100, mouseX, mouseY);
  vectorSubstraction(200, 100, 100, 500);
}

float[] vectorSubstraction(float P00x, float P00y, float P10x, float P10y) {

  // P10 - P00
  float Ax = P10x - P00x;
  float Ay = P10y - P00y;
  //float Az = P10z - P00z;
  
  //Render
  stroke(255);
  //Vector of point P00
  beginShape(LINES);
  vertex(0, 0, 0);
  vertex(P00x, P00y, 0);
  endShape();
  text("P00("+P00x+","+P00y+")", P00x, P00y);
  //Vector of point P10
  beginShape(LINES);
  vertex(0, 0, 0);
  vertex(P10x, P10y, 0);
  endShape();
  text("P00("+P10x+","+P10y+")", P10x, P10y);
  pushMatrix();
  //Vector A , distance between P10 - P00
  translate(P00x, P00y, 0 );
  stroke(255, 0, 0);
  beginShape(LINES);
  vertex(0, 0, 0);
  vertex(Ax, Ay, 0);
  endShape();
  popMatrix();
  
  float[] newVector = {Ax, Ay, 0, 0};
  return newVector;
}

void basicSetUp() {
  background(0);
  ambientLight(50, 50, 50, 0, 0, 0);
  pointLight(255, 255, 255, width/2, -height, 0);
  pushMatrix();
  translate(width/2, height/2, -100);
  noStroke();
  fill(255);
  //sphere(200);
  stroke(80);
  noFill();
  box(1280, 720, 500);
  popMatrix();
}

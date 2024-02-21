float[] P00, P10, P01, P11;
float[] vectorA, vectorB, vectorC, vectorD, AcrossB, CcrossD, ABNorm;

void setup() {
  size(1280, 720, P3D);
  P00 = new float[4]; //Affine coordinates
  P00[0] = 400;
  P00[1] = 200;
  P00[2] = -300;
  P00[3] = 1;
  P10 = new float[4]; //Affine coordinates
  P10[0] = 300;
  P10[1] = 500;
  P10[2] = 000;
  P10[3] = 1;
  P01 = new float[4]; //Affine coordinates
  P01[0] = 50;
  P01[1] = 400;
  P01[2] = -100;
  P01[3] = 1;
  P11 = new float[4]; //Affine coordinates
  P11[0] = 200;
  P11[1] = 100;
  P11[2] = 200;
  P11[3] = 1;
}

void draw() {
  basicSetUp();
  P10[0] = mouseX;
  P10[1] = mouseY;
  vectorA = vectorSubstraction(P00, P10);
  vectorB = vectorSubstraction(P00, P01);
  vectorC = vectorSubstraction(P10, P01);
  vectorD = vectorSubstraction(P11, P01);
  
  AcrossB = crossProduct(vectorA, vectorB);
  vertorNorm(AcrossB);
  displayTriangle(P00, P10, P01);
}

void displayTriangle(float[] A, float[] B, float[] C) {
  noStroke();
  fill(255);
  beginShape(TRIANGLES);
  vertex(A[0], A[1], A[2]);
  vertex(B[0], B[1], B[2]);
  vertex(C[0], C[1], C[2]);
  endShape();
}

float[] vectorSubstraction(float[] P00, float[] P10) {

  // P10 - P00
  float Ax = P10[0] - P00[0]; // X1 - X0
  float Ay = P10[1] - P00[1]; // Y1 - Y0
  float Az = P10[2] - P00[2]; // Z1 - Z0

  //Render
  stroke(255);
  //Vector of point P00
  beginShape(LINES);
  vertex(0, 0, 0);
  vertex(P00[0], P00[1], P00[2]);
  endShape();
  //text("P00("+P00x+","+P00y+")", P00x, P00y);
  //Vector of point P10
  beginShape(LINES);
  vertex(0, 0, 0);
  vertex(P10[0], P10[1], P10[2]);
  endShape();
  //text("P00("+P10x+","+P10y+")", P10x, P10y);

  //Vector A , distance between P10 - P00
  pushMatrix();
  translate(P00[0], P00[1], P00[2]);
  stroke(255, 0, 0);
  beginShape(LINES);
  vertex(0, 0, 0);
  vertex(Ax, Ay, Az);
  endShape();
  popMatrix();

  float[] newVector = {Ax, Ay, Az, 0};
  return newVector;
}

float[] crossProduct(float[] vA, float[] vB) {

  //u x v = (uY*vZ - uZ*vY, uZ*vX - uX*vZ, uX*vY - uY*vX)

  float x = vA[1]*vB[2] - vA[2]*vB[1];
  float y = vA[2]*vB[0] - vA[0]*vB[2];
  float z = vA[0]*vB[1] - vA[1]*vB[0];

  //Vector Cross , cross product AxB;
  pushMatrix();
  translate(P00[0], P00[1], P00[2] );
  //stroke(0, 100, 0);
  beginShape();
  vertex(0, 0, 0);
  vertex(x, y, z);
  endShape();
  popMatrix();

  float[] newVector = {x, y, z, 0};
  return newVector;
}

float[] vertorNorm(float[] vector) {
  println("vertorNorm input: "+vector[0]);
  float vectorLenght = sqrt(pow(vector[0], 2)+pow(vector[1], 2)+pow(vector[2], 2));
  println("vectorLenght: "+vectorLenght);


  float xn = vector[0]/vectorLenght;
  float yn = vector[1]/vectorLenght;
  float zn = vector[2]/vectorLenght;
  println("xn: "+xn);
  println("yn: "+yn);
  println("zn: "+zn);
  println("xn + yn + zn = "+ (xn+yn+zn));

  //Normal Vector, 1/||V|| * [x,y,z]
  pushMatrix();
  translate(P00[0], P00[1], P00[2] );
  stroke(0, 0, 255);
  beginShape(LINES);
  vertex(0, 0, 0);
  vertex(xn*100, yn*100, zn*100);
  endShape();
  popMatrix();

  float[] normalizedVector = {xn, yn, zn, 1};// Affine coordinates
  return normalizedVector;
}

void basicSetUp() {
  background(0);
  ambientLight(10, 10, 10, 0, 0, 0);
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

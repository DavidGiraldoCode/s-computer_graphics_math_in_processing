import java.text.DecimalFormat;
float[] P00, P10, P01, P11;
float[] QOrigen; //2D Position of a chacter project over XZ plane.
float[] vectorQ; //The origntation and position of the chacter.
float[] vectorA, vectorB, vectorC, vectorD, crossBA, crossDC, ABNorm;

float[] A, B, C, P, I;

void setup() {
  size(1280, 720, P3D);
  P00 = new float[4]; //Affine coordinates
  P00[0] = 200;
  P00[1] = 650;
  P00[2] = -10;
  P00[3] = 1;
  P10 = new float[4]; //Affine coordinates
  P10[0] = 600;
  P10[1] = 650;
  P10[2] = -10;
  P10[3] = 1;
  P01 = new float[4]; //Affine coordinates
  P01[0] = 200;
  P01[1] = 650;
  P01[2] = -400;
  P01[3] = 1;
  P11 = new float[4]; //Affine coordinates
  P11[0] = 600;
  P11[1] = 400;
  P11[2] = -400;
  P11[3] = 1;

  QOrigen = new float[4]; //Affine coordinates
  QOrigen[0] = 0;
  QOrigen[1] = 650;
  QOrigen[2] = 0;
  QOrigen[3] = 1;

  vectorQ = new float[4]; //Affine coordinates
  vectorQ[0] = 0;
  vectorQ[1] = -1;
  vectorQ[2] = 0;
  vectorQ[3] = 1;

  A = new float[4]; //Affine coordinates
  A[0] = 100;
  A[1] = 100;
  A[2] = 0;
  A[3] = 1;

  B = new float[4]; //Affine coordinates
  B[0] = 130;
  B[1] = 10;
  B[2] = 0;
  B[3] = 1;

  C = new float[4]; //Affine coordinates
  C[0] = 0;
  C[1] = 0;
  C[2] = 0;
  C[3] = 1;

  P = new float[4]; //Affine coordinates
  P[0] = 30;
  P[1] = 10;
  P[2] = 0;
  P[3] = 1;
}

void draw() {
  basicSetUp();
  //P11[0] = mouseX;
  //P11[1] = mouseY;

  vectorA = vectorSubstraction(P10, P00);
  vectorB = vectorSubstraction(P01, P00);
  vectorC = vectorSubstraction(P01, P11);
  vectorD = vectorSubstraction(P10, P11);

  crossBA = crossProduct(vectorB, vectorA);
  crossDC = crossProduct(vectorD, vectorC);
  vertorNorm(crossBA, P00);
  vertorNorm(crossDC, P11);

  displayTriangle(P00, P10, P01);
  displayTriangle(P11, P01, P10);

  chacterProjectRay();

  displaySegment(A, B);
  displayRay(C, P);
  I = intersectionPoint(P);
  displayInterseption(I);

  P[0] = mouseX;
  P[1] = mouseY;
  P[2] = -100;
  P[3] = 1;



  stroke(255, 0, 0);
  beginShape(LINES);
  vertex(width-100, 600, -100);
  vertex(width-100+(vectorQ[0]*100), (vectorQ[1]*100)+600, (vectorQ[2]*100)-100);
  endShape();

  float[] I = computeIntersectionOntoPlane(P00, vertorNorm(crossBA, P00), P);

  pushMatrix();
  translate(I[0], I[1], I[2]);
  fill(0, 255, 0);
  sphere(5);
  popMatrix();
}

float[] computeIntersectionOntoPlane(float[] knownPointOnPlane, float[] normalOnPLane, float[] rayVector) {

  float A = normalOnPLane[0]*knownPointOnPlane[0] + normalOnPLane[1]*knownPointOnPlane[1] + normalOnPLane[2]*knownPointOnPlane[2];
  float B = normalOnPLane[0]*rayVector[0] + normalOnPLane[1]*rayVector[1] + normalOnPLane[2]*rayVector[2];
  float t = A/B;

  float[] I = new float[4];

  println(t);
  I[0] = rayVector[0] * t;
  I[1] = rayVector[1] * t;
  I[2] = rayVector[2] * t;

  return I;
}

void displaySegment(float[] A, float[] B) {
  stroke(255, 255, 0);
  beginShape(LINES);
  vertex(A[0], A[1], A[2]);
  vertex(B[0], B[1], B[2]);
  endShape();
}

void displayRay(float[] origin, float[] tip) {
  int scalar = 10;
  stroke(255);
  beginShape(LINES);
  vertex(origin[0], origin[1], origin[2]);
  vertex(tip[0]*scalar, tip[1]*scalar, tip[2]*scalar);
  endShape();
}

void displayInterseption(float[] location) {
  pushMatrix();
  noStroke();
  fill(255, 0, 0);
  translate(location[0], location[1], location[2]);
  sphere(5);
  popMatrix();
}

float[] intersectionPoint(float[] rayVector) {
  float[] I = new float[4];
  /*
  P is the tip of the rayVector
   
   Ix = (1-t)* Cx + t*Px
   Iy = (1-t)* Cy + t*Py
   
   Iy = m*Ix + b
   
   */
  float t = 4;
  I[0] = t*rayVector[0];
  I[1] = t*rayVector[1];

  return I;
}

void mousePressed() {


  float area = determinant(P00, P10, P01);
  float factor = 1/(2*area);

  float det0 = determinant(QOrigen, P10, P01);
  float det2 = determinant(P00, P10, QOrigen);
  float det3 = determinant(P00, QOrigen, P01);

  float U = factor*det0;
  float V = factor*det2;
  float W = factor*det3;

  println("determinant(P00, P10, P10): "+area);
  println("U:"+U+" V:"+V+" W:"+W+" U+V+W: "+(U+V+W));
}

float determinant(float[] A1, float[] A2, float[] A3) {
  DecimalFormat numformat = new DecimalFormat("#.00");

  float a11 = A1[0];
  float a21 = A1[1];
  float a31 = A1[2];

  float a12 = A2[0];
  float a22 = A2[1];
  float a32 = A2[2];

  float a13 = A3[0];
  float a23 = A3[1];
  float a33 = A3[2];

  float det = (a11*a22*a33)+(a12*a23*a32)+(a31*a21*32)-(a11*a23*a32)-(a12*a21*a33)-(a13*a22*31);
  //println("numformat: "+ numformat.format(det));
  return det;
}

void chacterProjectRay() {
  QOrigen[0] = mouseX;
  QOrigen[1] = 650;
  QOrigen[2] = mouseY*-1;

  stroke(255, 0, 0);
  beginShape(LINES);
  vertex(QOrigen[0], QOrigen[1], QOrigen[2]);
  vertex(QOrigen[0], QOrigen[1]-height, QOrigen[2]);
  endShape();
}

void displayTriangle(float[] A, float[] B, float[] C) {
  noStroke();
  fill(200);
  beginShape(TRIANGLES);
  vertex(A[0], A[1], A[2]);
  vertex(B[0], B[1], B[2]);
  vertex(C[0], C[1], C[2]);
  endShape();
}

float[] vectorSubstraction(float[] P1, float[] P0) {

  // P10 - P00
  float Ax = P1[0] - P0[0]; // X1 - X0
  float Ay = P1[1] - P0[1]; // Y1 - Y0
  float Az = P1[2] - P0[2]; // Z1 - Z0

  //Render
  stroke(50);
  //Vector of point P0
  beginShape(LINES);
  vertex(0, 0, 0);
  vertex(P0[0], P0[1], P0[2]);
  endShape();
  //text("P00("+P00x+","+P00y+")", P00x, P00y);
  //Vector of point P1
  beginShape(LINES);
  vertex(0, 0, 0);
  vertex(P1[0], P1[1], P1[2]);
  endShape();
  //text("P00("+P10x+","+P10y+")", P10x, P10y);

  //Vector A , distance between P10 - P00
  pushMatrix();
  translate(P0[0], P0[1], P0[2]);
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

float[] vertorNorm(float[] vector, float[]offsetOrigin) {
  //println("vertorNorm input: "+vector[0]);
  float vectorLenght = sqrt(pow(vector[0], 2)+pow(vector[1], 2)+pow(vector[2], 2));
  //println("vectorLenght: "+vectorLenght);


  float xn = vector[0]/vectorLenght;
  float yn = vector[1]/vectorLenght;
  float zn = vector[2]/vectorLenght;
  //println("xn: "+xn);
  //println("yn: "+yn);
  //println("zn: "+zn);
  //println("xn + yn + zn = "+ (xn+yn+zn));

  //Normal Vector, 1/||V|| * [x,y,z]
  pushMatrix();
  translate(offsetOrigin[0], offsetOrigin[1], offsetOrigin[2] );
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
  ambientLight(90, 90, 90, 0, 0, 0);
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

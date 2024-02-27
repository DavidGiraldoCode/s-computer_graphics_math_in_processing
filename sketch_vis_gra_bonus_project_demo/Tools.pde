public class Tools {

  //private float[] identityMatrix = {1, 0, 0, 0, 1, 0, 0, 0, 1};

  public Tools() {
  }

  float linearInterpolationN( float t, float startSample, float endSample) {
    /*
  Special case in which "t" belongs [0,1]
     (1-t)*f(X0) + t*f(X1)
     */
    float interpolated = ((1-t) * startSample) + (t*endSample);
    return interpolated;
  }

  public float[] applyMatrix3(float[] vector, float[] matrix) {
    //vector most be [x,y,1]
    float[] newVector = new float[3];
    for (int i = 0; i < 3; i++) {
      newVector[0] += vector[(i%3)]*matrix[(i%3)];
      newVector[1] += vector[(i%3)]*matrix[(i%3)+3];
      //println();
      //y*nx + x
      //Math.floor(i/3)
    }
    return newVector;
  }
  public float[] applyMatrix4(float[] vector, float[] matrix) {
    //vector most be [x,y,1]
    float[] newVector = new float[4];
    int size = vector.length;
    for (int i = 0; i < size; i++) {
      newVector[0] += vector[(i%size)]*matrix[(i%size)];
      newVector[1] += vector[(i%size)]*matrix[(i%size)+size];
      newVector[2] += vector[(i%size)]*matrix[(i%size)+(size*2)];

      //println();
      //y*nx + x
      //Math.floor(i/3)
    }
    newVector[3] = 1;
    return newVector;
  }


  float[] vectorSubstraction(float[] P1, float[] P0) {
    // FinalPoint - InitialPoint
    float Ax = P1[0] - P0[0]; // X1 - X0
    float Ay = P1[1] - P0[1]; // Y1 - Y0
    float Az = P1[2] - P0[2]; // Z1 - Z0

    float[] newVector = {Ax, Ay, Az, 1}; //Affine coordinates
    return newVector;
  }

  float[] crossProduct(float[] vA, float[] vB) {
    //u x v = (uY*vZ - uZ*vY, uZ*vX - uX*vZ, uX*vY - uY*vX)
    float x = vA[1]*vB[2] - vA[2]*vB[1];
    float y = vA[2]*vB[0] - vA[0]*vB[2];
    float z = vA[0]*vB[1] - vA[1]*vB[0];

    float[] newVector = {x, y, z, 1};
    return newVector;
  }

  float[] vertorNorm(float[] vector) {
    //offsetOrigin is used to move the normal vecotr from [0,0] to the tip of the position vectors
    float vectorLenght = sqrt(pow(vector[0], 2)+pow(vector[1], 2)+pow(vector[2], 2));

    float xn = vector[0]/vectorLenght;
    float yn = vector[1]/vectorLenght;
    float zn = vector[2]/vectorLenght;

    float[] normalizedVector = {xn, yn, zn, 1};// Affine coordinates
    return normalizedVector;
  }

  float[] findTriangleBarycenter(float[] A, float[] B, float[] C) {
    float[] newVector = new float[4];
    float weight = 0.33;

    newVector[0] = (weight*A[0]) + (weight*B[0]) + (weight*C[0]);
    newVector[1] = (weight*A[1]) + (weight*B[1]) + (weight*C[1]);
    newVector[2] = (weight*A[2]) + (weight*B[2]) + (weight*C[2]);
    newVector[3]=1;

    return newVector;
  }
}

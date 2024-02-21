public class Tool {
  
  //private float[] identityMatrix = {1, 0, 0, 0, 1, 0, 0, 0, 1};

  public Tool() {
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
    for (int i = 0; i < newVector.length; i++) {
      newVector[0] += vector[(i%4)]*matrix[i];
      newVector[1] += vector[(i%4)]*matrix[i+4];
      newVector[2] += vector[(i%4)]*matrix[i+8];
      //println();
      //y*nx + x
      //Math.floor(i/3)
    }
    
    return newVector;
  }
}

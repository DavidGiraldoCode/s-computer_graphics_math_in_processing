public class Tool {

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

}

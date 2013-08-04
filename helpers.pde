
boolean pixelCheck(int pixelVal){
  return pixelBrightnessCheck(pixelVal);
  
}

boolean pixelBrightnessCheck(int pixelVal){
  // Determine the brightness of the pixel
  float pixelBrightness = brightness(pixelVal);
  if(pixelBrightness > brightestThreshold) return true;
  else return false;
  
}
  
// choose max value and check if it's big enough
int findMax(int[] numsarray){
  int maxValue = numsarray[0];
  int maxIndex = -1;
  for (int i = 1; i < numsarray.length; i++) {
    if (numsarray[i] > maxValue) {
    maxValue = numsarray[i];
    maxIndex = i;
    }
  }
  //print("max value is " + maxValue);
  //println(" at position " + maxIndex);
  
  if(maxValue > pixsThreshold){
    return maxIndex;
  }else{
    return -1;
  }
}

int rescalePosition(int pos, float rescale, int displace){
 // return int(pos*rescaleFactor+displace);
 float d = (pos*rescale - displace)/6;
  return int(pos*rescale + d);
}

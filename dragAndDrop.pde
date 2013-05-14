
import codeanticode.gsvideo.*;
GSCapture video;

int noi ;

ImgDrag[] draggers;
float cx,cy;
int xmr,ymr;
boolean mr,mu;

int brightestThreshold;
int pixsThreshold;
//video capture params
int wcap,hcap,totalW,totalH;
float rescaleFactor;
int[]xsums, ysums;

PImage destination; 

//proyector 1024x768
// ?? configurar la camara
// ? salida por proyector
// ignorar el punto de luz que genera el proyector

void setup(){
  //size(totalW,totalH);
  wcap = 320;
  hcap = 240;
  rescaleFactor = 3.2;
  totalW = int(wcap*rescaleFactor);
  totalH = int(hcap*rescaleFactor);
  size(totalW, totalH);
  //colorMode(HSB, 360, 100, 100);
  // size(screen.width, screen.height);
  
  // set thresholds
  brightestThreshold = 220;
  pixsThreshold = 3;
  
  // start camara
  //video = new GSCapture(this, wcap, hcap);
  video = new GSCapture(this, wcap, hcap, "/dev/video1");

  video.start();
 
  // load pictures from folders normal and over
  java.io.File folder = new java.io.File(dataPath("normal"));
  String[] filenames = folder.list();
  noi = filenames.length;

  draggers = new ImgDrag[noi];
  String current;
  for (int i = 0; i < filenames.length; i++) {
    current = filenames[i];
    draggers[i]= new ImgDrag(random(totalW), random(totalH), loadImage("normal/"+current),loadImage("over/"+current));

  }
  
  //destination = createImage( wcap, hcap, RGB);
  destination = createImage( wcap, hcap, RGB);
  destination.loadPixels();
  xmr = -1;
  ymr = -1;
}
  
void draw(){
  background(0);

  // todo: implement function for pictures separation if they are too close
  
  if (video.available()) {
    video.read();
    
    video.loadPixels();
    int index = 0;
  
    xsums = new int[wcap];
    ysums = new int[hcap];
  
    for (int y = 0; y < hcap; y++) {
      for (int x = 0; x < wcap; x++) {
        // Get the color stored in the pixel
        int pixelValue = video.pixels[index];

        if (pixelCheck(pixelValue)) {
          xsums[x]+=1;
          ysums[y]+=1;
          destination.pixels[index] = color(255);
        }else{
         destination.pixels[index] = color(brightness(pixelValue)); 
         //destination.pixels[index] = color(0); 
        }
        index++;
      }
    }
    // check maxs
    int xm = findMax(xsums);
    int ym = findMax(ysums);   
    destination.updatePixels();
    // Display the destination
    fill(255,0,0);
    rect(0,0,wcap+5,hcap+5);
    image(destination,0,0);
    if( xm != -1 && ym != -1){
      xmr = rescalePosition(xm);
      ymr = rescalePosition(ym);
      rect(xmr,ymr,10,10);
    }
  }else{println("novideo");}
  updateimages(xmr,ymr);
}
  
boolean sketchFullScreen() {
  return true;
}
  
void updateimages(float mx, float my){
  boolean keepChecking = true;
  for (int i=noi-1;i<0;i--){
    if(keepChecking){
      if(draggers[i].isMouseover(mx,my)){
        keepChecking = false;
      }
    }
  }
  for (int i=0;i<noi;i++){
    draggers[i].draw();
  }
}

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
  print("max value is " + maxValue);
  println(" at position " + maxIndex);
  
  if(maxValue > pixsThreshold){
    return maxIndex;
  }else{
    return -1;
  }
}

int rescalePosition(int pos){
  return int(pos*rescaleFactor);
}

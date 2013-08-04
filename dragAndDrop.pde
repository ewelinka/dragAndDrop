
import codeanticode.gsvideo.*;
GSCapture video;
import java.awt.Rectangle;
import java.awt.*;

int noi ;

ImgDrag[] draggers;
float cx,cy;
int xmr,ymr;
boolean mr,mu;

int brightestThreshold;
int pixsThreshold;
//video capture params
int wcap,hcap,totalW,totalH;
float rescaleFactorX,rescaleFactorY;
int displaceX, displaceY;
int[]xsums, ysums;

PImage destination; 
PImage back; 
Rectangle monitor = new Rectangle();

// ?? configurar la camara
// ? salida por proyector
// ignorar el punto de luz que genera el proyector

void setup(){
  //size(totalW,totalH);
  back = loadImage("sezam1440x900.gif");  
  wcap = 320;
  hcap = 240;
  rescaleFactorX = 4.5;  
  rescaleFactorY = 3.75;  


  totalW = int(wcap*rescaleFactorX);
  totalH = int(hcap*rescaleFactorY);
  displaceX = 0;
  displaceY = totalH/2;
  println("totalW: "+totalW+" totalH: "+totalH);
  //proyector 1440x900
  size(totalW, totalH);



  
  // set thresholds
  brightestThreshold = 170;
  pixsThreshold = 1;
  
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
  xmr = -1;
  ymr = -1;
  //frame.setLocation(monitor.x, monitor.y);
  frame.setLocation(0, 0);
  frame.setAlwaysOnTop(true); 
  image(back,0,0);

  // todo: implement function for pictures separation if they are too close
  
//  if (false) {
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
    rect(0,0,wcap+4,hcap+4);
    image(destination,2,2);
    if( xm != -1 && ym != -1){
      //xmr = rescalePosition(xm,rescaleFactorX,displaceX);
      xmr = int(xm*rescaleFactorX);
      ymr = rescalePosition(ym,rescaleFactorY,displaceY);
      rect(xmr,ymr,10,10);
      //rect(xm*rescaleFactorX,ym*rescaleFactorY,10,10);
    }
  }else{
    println("novideo");
  }
  updateimages(xmr,ymr);
  rect(totalW/2 -2, totalH/2 -2,4,4);
}
  
boolean sketchFullScreen() {
  return true;
}
  
void updateimages(float mx, float my){
  boolean keepChecking = true;
  for (int i=noi-1;i>-1;i--){
    if(keepChecking){
      if(draggers[i].isMouseover(mx,my)){
        println("is over!!! "+mx+" "+my);
        ImgDrag now = draggers[i];
        ImgDrag last = draggers[noi-1];
        draggers[i] = last;
        draggers[noi-1] = now;
        keepChecking = false;
      }
    }
  }
  for (int i=0;i<noi;i++){
    draggers[i].draw();
  }
}


public class ImgDrag{

   // PROPERTIES
  float x, y;
  boolean isOver;
  int w, h;
  PImage imgDefault,imgOver;

 ImgDrag(float x, float y, PImage imgDefault, PImage imgOver) {
   this.x = x;
   this.y = y;
   this.imgDefault = imgDefault;
   this.w = imgDefault.width;
   this.h = imgDefault.height;
   this.imgOver = imgOver;
   this.isOver = false;
   //registerDraw(this);
 }
 
  void displayDefault() {
    image(this.imgDefault,this.x,this.y);
  }
  
  void displayOver() {
    image(this.imgOver,this.x,this.y);
  }
  
  boolean isMouseover(float mx, float my) {
   // isOver = mx > x - 0.5*w && mx < x + 0.5*w && my > y-0.5*h && my < y+0.5*h;
    isOver = (mx > x) && (mx < (x + w)) && (my > y) && (my < (y + h));
    if(isOver){
      this.x = outOfBorder(negativeControl(mx - 0.5*w), w, totalW);
      this.y = outOfBorder(negativeControl(my - 0.5*h), h, totalH);
      //TODO ojo abajo!no permitir arrastrar para afuera
    }
   return isOver; 
  }
  
  float outOfBorder(float position, int objDim,int total){
    if(position + objDim > total){
      return total - objDim;
    }
    return position;
  }
  
  float negativeControl(float position){
    if(position < 0){
      return 0;
    }
    return position;
  }

  void draw() {    
    if(!this.isOver) {
      displayDefault();
    }
    else {
      displayOver();
    }
  }
  
}

class setType{
  int type;
  float w, h, x, y;
  float halfWidth, halfHeight;
  
  setType(float tempX,float tempY,float tempW,float tempH, int tempType){
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
    type = tempType;
    halfWidth = w/2;
    halfHeight = h/2;
  }
}

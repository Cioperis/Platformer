public class Player{
    float x, y, w, h, vx, vy, jumpForce;
    float speedX, speedY, maxSpeed, gravity, friction, bounce;
    boolean isOnGround;
    String collisionSide;
    int currentFrame,frameSequence,frameOffset;
    
    PImage[] standLeft;
    PImage[] standRight;
    PImage[] jumpLeft;
    PImage[] jumpRight;
    PImage[] moveLeft;
    PImage[] moveRight;
    
    Player(){
      //player values
      x = 0;
      y = 0;
      w = tileS*scale;
      h = tileS*scale;
      maxSpeed = 10;
      vx = 0;
      vy = 0;
      speedX = 0;
      speedY = 0;
      jumpForce = -15;
      isOnGround = false;
      collisionSide="";
      
      //world values
      gravity = 0.6;
      bounce = 0;
      friction = 0;  
      
      //animation
      currentFrame = 0;
      frameSequence = 3;
      frameOffset = 0;

      standRight = new PImage[3];
      standRight[0] = loadImage("playerStandRight1.png");
      standRight[1] = loadImage("playerStandRight2.png");
      standRight[2] = loadImage("playerStandRight3.png");

      jumpLeft = new PImage[3];
      jumpLeft[0] = loadImage("playerJumpLeft1.png");
      jumpLeft[1] = loadImage("playerJumpLeft2.png");
      jumpLeft[2] = loadImage("playerJumpLeft3.png");

      jumpRight = new PImage[3];
      jumpRight[0] = loadImage("playerJumpRight1.png");
      jumpRight[1] = loadImage("playerJumpRight2.png");
      jumpRight[2] = loadImage("playerJumpRight3.png");

      moveLeft = new PImage[3];
      moveLeft[0] = loadImage("playerRunLeft1.png");
      moveLeft[1] = loadImage("playerRunLeft2.png");
      moveLeft[2] = loadImage("playerRunLeft3.png");

      moveRight = new PImage[3];
      moveRight[0] = loadImage("playerRunRight1.png");
      moveRight[1] = loadImage("playerRunRight2.png");
      moveRight[2] = loadImage("playerRunRight3.png");
      
    }
    void update(){
      //horizontal movement
      if(left && !right){
        speedX = -0.8; 
        friction = 1;
      }
      if(!left && right) {
        speedX = 0.8;
        friction = 1;
      }
      if(!left && !right) speedX=0;
      
      //vertical movement
      if(up && isOnGround){
         vy = jumpForce;
         isOnGround=false;
         friction=1;
      }
      if(!up && !left && !right){
        friction=0.7;
      }
      
      vx += speedX;
      vy += speedY;
      
      vx *= friction;
      vy += gravity;
      
      if(vx > maxSpeed) vx = maxSpeed;
      if(vx < -maxSpeed) vx = -maxSpeed;
      if(vy > 3*maxSpeed) vy = 3*maxSpeed;
      
      if(abs(vx)<0.2) vx=0;
      
      //move player
      x += vx;
      y += vy;
      
      checkBounds();
    }
    
    void checkBounds(){
      if(x<0){
        vx *= bounce;
        x = 0;
      }
      if(x+w > gridX*tileS*scale){
        vx *= bounce;
        x = gridX*tileS*scale-w;
      }
      if(y<0){
        vy *= bounce;
        y = 0;
      }
      if(y+h > height){
        isOnGround=true;
        vy=0;
        y=height-h;
      }
    }
    void checkPlatforms(){
      if (collisionSide == "bottom" && vy >= 0) {
        if (vy < 1) {
          isOnGround = true;
          vy = 0;
        } else {
          //reduced bounce for floor bounce
          vy *= bounce/2;
        }
      } else if (collisionSide == "top" && vy <= 0) {
        vy = 0;
      } else if (collisionSide == "right" && vx >= 0) {
        vx = 0;
      } else if (collisionSide == "left" && vx <= 0) {
        vx = 0;
      }
      if (collisionSide != "bottom" && vy > 0) {
        isOnGround = false;
      }
    }
    void display(){
      //if (abs(vx) > 0)  image(imgArr[currentFrame+3], x, y+10,tileS*scale,tileS*scale);
      //else image(imgArr[3], x, y+10,tileS*scale,tileS*scale);
      //if (isOnGround) currentFrame = (currentFrame + 1)%frameSequence;
      //else currentFrame = 0;
      
      if(vx > 0 && isOnGround){
          image(moveRight[currentFrame], x, y, tileS*scale, tileS*scale);
      }
      else if(vx < 0 && isOnGround){
          image(moveLeft[currentFrame], x, y, tileS*scale, tileS*scale);
      }
      else if(vx > 0 && !isOnGround){
          image(jumpRight[currentFrame], x, y, tileS*scale, tileS*scale);
      }
      else if(vx < 0 && !isOnGround){
          image(jumpLeft[currentFrame], x, y, tileS*scale, tileS*scale);
      }
      else if(vx == 0){
          image(standRight[currentFrame], x, y, tileS*scale, tileS*scale);
      }
      
      currentFrame = (currentFrame + 1) % frameSequence;
    }
}

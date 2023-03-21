// general values
int coins = 0;
int tileS = 16;
int col, row;
int id = 0;
int currentLevel = 1;
int gridX, gridY;
int scale = 2;
int scaleTileMap = 4;
color buttonColor = color(166);
color buttonHighlight = color(45, 34, 223);
int buttonSize[] = {300, 100};
int buttonX = 430, playY = 250, editY = 400;
float textS = 80;

// map and setTypes
Table table;
PImage tileMap;
//PImage npc;
PImage[] imgArr;
int[][] map;
int[][] pl;
setType[][] type;

// screens
boolean editor = false;
boolean overPlay = false, overEdit = false;
boolean titleWindow = true, playWindow = false, endWindow = false;
Visibility camera;
Visibility gameWorld;

// player
boolean left = false;
boolean right = false;
boolean up = false;
Player player;

void setup(){
  size(1280, 705);
  tileMap = loadImage("tilemap.png");
  loadMap(1);
  fillArr();
}

void draw(){  
  if(titleWindow == true){
    update(mouseX, mouseY);
    title();
  }
  
  if(editor == true){
    openEditor(); 
  }
  
  if(endWindow){ 
    playWindow = false;
    end();
  }
  
  if(playWindow){
    background(0);
    pushMatrix();
    player.update();
    chooseMap();
    moveCamera(); 
    drawMap();
    player.display();
    popMatrix();x
    
    text("Coins: " + coins, 1000, 100);
  }
}

void chooseMap(){
  for(int i=0; i<gridY; i++){
     for(int j=0; j<gridX; j++){
       if(type[i][j].type != 0){
           player.collisionSide = collisions(player, type[i][j]);
           if(player.collisionSide != "none"){
             switch(type[i][j].type){
               case 2:
                 play(currentLevel);
                 break;
               case 3:
                 coins += 1;
                 if(currentLevel == 3) endWindow=true;
                 else play(currentLevel+1);
                 break;
             }
           }
          player.checkPlatforms();
        }
      }
    } 
}

void moveCamera(){
    camera.x = floor(player.x + (player.w/2) - (camera.w/2));
    camera.y = floor(player.y + (player.y/2) - (camera.h/2));
    if(camera.x < gameWorld.x) camera.x = gameWorld.x;
    if(camera.y < gameWorld.y) camera.y = gameWorld.y;
    if(camera.x + camera.w > gameWorld.x + gameWorld.w) camera.x = gameWorld.x + gameWorld.w - camera.w;
    if(camera.y + camera.h > gameWorld.h) camera.y = gameWorld.h - camera.h;  
    translate(-camera.x, -camera.y);
}

void update(int x, int y){
  if(x >= buttonX && x <= buttonX + buttonSize[0] &&
     y >= playY && y<= playY+buttonSize[1]){
     overPlay = true;
     overEdit = false;
  }
  else if(x >= buttonX && x <= buttonX + buttonSize[0] &&
     y >= editY && y<= editY + buttonSize[1]){
       overPlay = false; 
       overEdit = true;
  }
  else{
    overPlay = overEdit = false;
  }
}

void play(int n){
  background(0);
  noCursor();
  loadMap(n);
  scale=4;
  player = new Player();
  pl = new int[gridY][gridX];
  loadsetTypes();
  gameWorld = new Visibility(0,0,gridX*tileS*scale,gridY*tileS*scale);
  camera = new Visibility(0,0,width,height);
  camera.x = (gameWorld.x + gameWorld.w / 2)-camera.w / 2;
  camera.y = (gameWorld.y + gameWorld.h / 2)-camera.h / 2;
  currentLevel = n;
}

void mouseReleased(){
  if(titleWindow && overPlay){
    titleWindow = false;
    playWindow = true;
    play(1);
  }
  if(titleWindow && overEdit){
    titleWindow = false;
    editor = true;
  }
}

void fillArr(){
  col = tileMap.width / tileS;
  row = tileMap.height / tileS;
  print("Col: ", col, " row: ", row);
  
  imgArr = new PImage[col * row];
  for(int i=0; i<row; i++){
    for(int j=0; j<col; j++){
      imgArr[i*col+j] = tileMap.get(j*tileS, i*tileS, tileS, tileS);
    }
  }
}

void loadMap(int n){
  switch(n){
    case 1:
      table = loadTable("map1.csv");
      break;
    case 2:
      table = loadTable("map2.csv");
      break;
    case 3:
      table = loadTable("map3.csv");
      break;
  }
  gridX = table.getColumnCount();
  gridY = table.getRowCount();
  
  map = new int[gridY][gridX];
  
  for(int i=0; i<gridY; i++){
    for(int j=0; j<gridX; j++){
      map[i][j] = table.getInt(i, j); 
    }
  }
}

void saveMap(){
  gridY = table.getRowCount();
  gridX = table.getColumnCount();
  table = new Table();
  for(int i=0; i<gridY; i++)
    table.addRow(); 
    
  for(int i=0; i<gridX; i++)
    table.addColumn(); 
  
  for(int i=0; i<gridY; i++){
    for(int j=0; j<gridX; j++){
      table.setInt(i, j, map[i][j]);
      print("\n", map[i][j]);
    }
  }
  
  switch(currentLevel){
    case 1:
      saveTable(table, "map1.csv");
      break;
    case 2:
      saveTable(table, "map2.csv");
      break;
    case 3:
      saveTable(table, "map3.csv");
      break;
  }
}

void drawMap(){
  for(int i=0; i<gridY; i++){
    for(int j=0; j<gridX; j++){
      int tempX = i*tileS*scale;
      int tempY = j*tileS*scale;
      image(imgArr[map[i][j]], tempY, tempX, tileS*scale, tileS*scale);
    }
  }
}

void keyPressed(){
  if(keyCode == '1'){
     if(editor){
         saveMap();
         currentLevel = 1;
         loadMap(1);
       }
  }
  else if(keyCode == '2'){
     if(editor){
         saveMap();
         currentLevel = 2;
         loadMap(2);
      }
  }
  else if(key == '3'){
     if(editor){
         saveMap();
         currentLevel = 3;
         loadMap(3);
       }
  }
  else if(key == 'e'){
     if(editor) saveMap();
       loadMap(1);
       currentLevel = 1;
       editor = false;
       playWindow = false;
       endWindow = false;
       titleWindow = true;
       scale = 2;
       cursor();
  }
  else if ((keyCode == RIGHT) || (keyCode == 'D')) {
    right = true;
  } else if ((keyCode == LEFT) || (keyCode == 'A')) {
    left = true;
  } else if ((keyCode == UP) || (keyCode == 'W')) {
    up = true;
  }
}

void keyReleased(){
   if ((keyCode == RIGHT) || (keyCode == 'D')) {
    right = false;
  } else if ((keyCode == LEFT) || (keyCode == 'A')) {
    left = false;
  } else if ((keyCode == UP) || (keyCode == 'W')) {
    up = false;
  }
}

void mousePressed(){
  if(editor && mouseX <= width / scaleTileMap && mouseY <= height / scaleTileMap){
    int tempX = mouseX / (width / scaleTileMap / col);
    int tempY = mouseY / (height / scaleTileMap / row);
    id = tempY * col + tempX;
    print("\nID: ", id);
  }
  if(editor && mouseY >= 256 && mouseY <= 640 && mouseX <= 832){
    int tempX = mouseX / 32;
    int tempY = (mouseY - 256) / 32;
    map[tempY][tempX] = id;
   }
}

void openEditor(){
  background(0);
  image(tileMap, 0, 0, width/scaleTileMap, height/scaleTileMap);
  
  fill(255);
  textSize(50);
  text("Press 1 or 2 or 3 to cycle maps", 400, 200);
  
  //print("\nTILEMAP X: ", width/scaleTileMap, "TILEMAP Y: ", height/scaleTileMap);
  //print("\nmouseX: ", mouseX, "mouseY: ", mouseY);
  //rect(0, 0, width/scaleTileMap, height/scaleTileMap);
  noFill();
  stroke(255);
  
  for(int i=0; i<gridY; i++){
    for(int j=0; j<gridX; j++){
      int tempX = j*tileS*scale;
      int tempY = i*tileS*scale+width/5;
      image(imgArr[map[i][j]], tempX, tempY, tileS*scale, tileS*scale);
      rect(tempX, tempY, tileS*scale, tileS*scale);
    }
  }
  image(imgArr[id], mouseX+tileS, mouseY+tileS, tileS*scale, tileS*scale);
}

// 0-background, 1-setType, 2-reset level, 3-next level
void loadsetTypes(){
  for(int i=0; i<gridY; i++){
    for(int j=0; j<gridX; j++){
      if(map[i][j] <= 76){
        pl[i][j] = 1; 
      }
      if(map[i][j] == 22 || map[i][j] == 29 || map[i][j] == 36 || (map[i][j] >= 45 && map[i][j] <= 48)
      || (map[i][j] >= 51 && map[i][j] <= 55) || (map[i][j] >= 56 && map[i][j] <= 62)
      || (map[i][j] >= 63 && map[i][j] <= 69) || (map[i][j] >= 70 && map[i][j] <= 76)){
        pl[i][j] = 0; 
      }
      if(map[i][j] == 54 || map[i][j] == 55 || map[i][j] == 61 || map[i][j] == 62) pl[i][j]=3;
      if(map[i][j]==40) pl[i][j]=2;   
    }
  }
  
   type = new setType[gridY][gridX];
   for(int i=0; i<gridY; i++){
     for(int j=0; j<gridX; j++){
       type[i][j] = new setType(j*tileS*scale, i*tileS*scale, tileS*scale, tileS*scale, pl[i][j]);
   }
  }
}

void drawPlay(){
  rect(buttonX, playY, buttonSize[0], buttonSize[1]);
  fill(0);
  text("Play", buttonX + textS, playY + textS);
}

void drawEdit(){
  rect(buttonX, editY, buttonSize[0], buttonSize[1]);
  fill(0);
  text("Edit", buttonX + textS, editY + textS);
}

void end(){
  background(90);
  fill(255);
  textSize(64);
  text("You beat the game!", 350, 200);
  textSize(48);
  text("Press ESC to leave", 400, 450);
}

void title(){
  titleWindow = true;
  background(90);
  fill(255);
  textSize(128);
  text("Platformer", 300, 200);
  textSize(textS);
  if(overPlay){
      fill(buttonHighlight);
      drawPlay();
      fill(buttonColor);
      drawEdit();
    }
    else if(overEdit){
      fill(buttonColor);
      drawPlay();
      fill(buttonHighlight);
      drawEdit();
    }
    else{
      fill(buttonColor);
      drawPlay();
      fill(buttonColor);
      drawEdit();
    }
}

String collisions(Player r1, setType r2){
    float dx = (r1.x + r1.w / 2) - (r2.x + r2.w / 2);
    float dy = (r1.y + r1.h / 2) - (r2.y+r2.h / 2);
  
    float combinedHalfWidths = (r1.w / 2) + r2.halfWidth;
    float combinedHalfHeights = (r1.w / 2) + r2.halfHeight;
  
    if (abs(dx) < combinedHalfWidths) {
      if (abs(dy) < combinedHalfHeights) {
        float overlapX = combinedHalfWidths - abs(dx);
        float overlapY = combinedHalfHeights - abs(dy);
        if (overlapX >= overlapY){
          if (dy > 0) {
            r1.y += overlapY;
            return "top";
          }
          else{
            r1.y -= overlapY;
            return "bottom";
          }
        }
        else{
          if (dx > 0) {
            r1.x += overlapX;
            return "left";
          }
          else{
            r1.x -= overlapX;
            return "right";
          }
        }
      }
      else{
        //collision failed on the y axis
        return "none";
      }
    }
    else{
      //collision failed on the x axis
      return "none";
    }
}

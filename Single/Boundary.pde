class Boundary {
    int boundary;
    int boundcount =0;
   
    Boundary (int b) {
      boundary = b;
    }
    
   void setup() {
    noFill();
    stroke(150);
    strokeWeight(1);
    //frameRate(customframerate);
   }
   
   void drawsur () {
     boundcount++;
     
      background(0);
      translate(width/2, height/2, 200);
      rotateY(frameCount / 200.0); 
      if(environment == "box"){
        box(boundary);
      }else if(environment == "sphere"){
        //boundary = boundary;
        sphere((boundary * 0.866));
      } 
      //noLoop();
   }
}

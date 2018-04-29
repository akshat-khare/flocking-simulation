class Boundary {
    int boundary;
   
    Boundary (int b) {
      boundary = b;
    }
    
   void setup() {
    noFill();
    stroke(255);
    strokeWeight(1);
   }
   
   void draw () {
      background(0);
      translate(width/2, height/2, 200);
      //rotateY(frameCount / 100.0); 
      println (boundary);
      box(boundary);  
   }
}

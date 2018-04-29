class Avoid {
  PVector pos;
   
    Avoid (float xx, float yy, float zz) {
      pos = new PVector(xx,yy,zz);
    }
   
   void go () {
     
   }
   
   //void setup () {
   // stroke(255);
   // strokeWeight(1);
   // frameRate(customframerate);
   //}
   
   void drawthi () {
     pushMatrix();
     fill(0, 255, 200);
     translate(pos.x, pos.y, pos.z);
     box(10);  
     popMatrix();
   }
}

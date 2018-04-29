class Boundary {
    int boundary;
    int boundcount =0;
    float begwid =0;
    //volatile PImage tryme = bg.get(0,0,width, height);
    int thiwid = 0;
   
    Boundary (int b) {
      boundary = b;
    }
    
   //void setup() {
   // //noFill();
   // //stroke(150);
   // //strokeWeight(1);
   // //frameRate(customframerate);
   //}
   public void changeBackground(){
     tempbg = bg.get(thiwid,0,width, height);
   }
   void drawsur () {
     
     boundcount++;
     //float begwid = (frameCount%(1256))/1256;
     if((begwid/1256) * width + width >bg.width || begwid >=1256){
       println("exceeded " + begwid);
       begwid = 0;
     }
     thiwid = (int) (begwid*width)/1256;
     //tryme = bg.get(thiwid,0,width, height);
     //println("size of to be rendered image is " + tryme.width +" "+ tryme.height + " width is " + width);
     //tryme.resize(width,height);
     if(frameCount%10==1){
       //tempbg = bg.get(thiwid,0,width, height);
       begwid++;
       //background(tryme);
     }
     //thread("changeBackground");
     //background(tempbg);
     //begwid++;
     
     //background(bg.get(thiwid,0,width, height));
     background(0);
     //image(bg,-thiwid,0,-thiwid+width, height);
     
      //background(0);
      translate(width/2, height/2, 200);
      if (rotate == 1)
        rotateY(frameCount / 200.0); 
  
      if(environment == "box"){
        box(boundary);
      }else if(environment == "sphere"){
        //boundary = boundary;
        sphereDetail(20,15);
        sphere((boundary * 0.866));
      } 
      //noLoop();
   }
}

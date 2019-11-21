import ddf.minim.*;
import ddf.minim.analysis.*;


class SoundWave{
  
Minim minim;
AudioPlayer player;
AudioMetaData meta;
BeatDetect beat;
float rad = 70;
float time = 0;
float dt = 0.01;

public SoundWave(AudioPlayer audioPlayer)
{
//  size(displayWidth, displayHeight);
  //size(600, 400);
  minim = new Minim(this);
  player = audioPlayer;
  meta = player.getMetaData();
  beat = new BeatDetect();
  //player.play();
//  background(-1);
}

public void draw(float xPos, float yPos, AudioPlayer audioPlayer, int state)
{ 
  player = audioPlayer;
  
  if(state == 2){
    int r = 20 + (int)(15* currentSoundVolume);
    beat.detect(player.mix);
    translate(xPos, yPos);
    noFill();
    fill(-1, 10);
    if (beat.isOnset()) rad = rad*0.9; //to change the size of the wave
    else rad = 70;
  
    //ellipse(0, 0, 2*rad, 2*rad);
    fill(255, 150);
    noStroke();
    //ellipse(0, 0, 15, 15);
    stroke(255, 50);
    int bsize = player.bufferSize();
    for (int i = 0; i < bsize - 1; i+=5)
    {
      float x = (r)*cos(i*2*PI/bsize);
      float y = (r)*sin(i*2*PI/bsize);
      float x2 = (r + player.left.get(i)*100)*cos(i*2*PI/bsize);
      float y2 = (r + player.left.get(i)*100)*sin(i*2*PI/bsize);
      line(x, y, x2, y2);
    }
    beginShape();
    noFill();
    stroke(255, 50);
    for (int i = 0; i < bsize; i+=30)
      {
        float x2 = (r + player.left.get(i)*100)*cos(i*2*PI/bsize);
        float y2 = (r + player.left.get(i)*100)*sin(i*2*PI/bsize);
        vertex(x2, y2);
        pushStyle();
        stroke(255);
        strokeWeight(3);
        point(x2, y2);
        popStyle();
      }
    endShape();
    noFill();
    noStroke();
    
  }
  else if(state == 1){
    time += dt;
    stroke(0,0,255);
    strokeWeight(5);
    noFill();
    
    float r= height/10;
    float pie = 3.1415927;
    
    
    translate(xPos, yPos);
    for(int i=8; i<16 ; i++){
      beginShape();
      for(float alpha=0; alpha<=2*pie; alpha+=pie/i){
        stroke(165,255,255,100/i);
        
        float x2 = (r + player.left.get(i)*100)*cos(i*2*PI/bsize);
        float y2 = (r + player.left.get(i)*100)*sin(i*2*PI/bsize);   
        
        float drift = (noise(r*cos(alpha)/300,r*sin(alpha)/300,time)-0.5)*750;
        vertex((r +drift+ player.left.get(i)*100)*cos(alpha),(r + drift + player.left.get(i)*100)*sin(alpha));
      }  
     endShape();
  }
  }
  else if(state == 0){
  time += dt;
  stroke(0,0,255);
  strokeWeight(5);
  noFill();
  
  float r= height/10;
  float pie = 3.1415927;
  
  translate(xPos, yPos);
  for(int i=8; i<16 ; i++){
    beginShape();
    for(float alpha=0; alpha<=2*pie; alpha+=pie/i){
      stroke(165,255,255,150/i);
      
      float x2 = (r + player.left.get(i)*100)*cos(i*2*PI/bsize);
      float y2 = (r + player.left.get(i)*100)*sin(i*2*PI/bsize);   
      
      float drift = (noise(x2,y2,time)-0.5)*750;
//      vertex((r +drift+ player.left.get(i)*100)*cos(alpha),(r + drift + player.left.get(i)*100)*sin(alpha));
      vertex((r+drift)*cos(alpha),(r+drift)*sin(alpha));
    }  
     endShape();
  }
  
  }

  
  //in main draw, when a point's soundWave is not there anymore, we don't want the fill and stroke remain on the position. 

}
boolean sketchFullScreen() {
  return true;
}


}

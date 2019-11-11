import ddf.minim.*;
import ddf.minim.analysis.*;


class SoundWave{
  
Minim minim;
AudioPlayer player;
AudioMetaData meta;
BeatDetect beat;
float rad = 70;
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
//  noCursor();
}

public void draw(float xPos, float yPos)
{ 
  int r = 20 + (int)(15* currentSoundVolume);
  beat.detect(player.mix);
  translate(xPos, yPos);
  noFill();
  fill(-1, 10);
  if (beat.isOnset()) rad = rad*0.9; //to change the size of the wave
  else rad = 70;

  //ellipse(0, 0, 2*rad, 2*rad);
  fill(0, 150);
  noStroke();
  //ellipse(0, 0, 15, 15);
  stroke(0, 50);
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
  stroke(0, 50);
  for (int i = 0; i < bsize; i+=30)
  {
    float x2 = (r + player.left.get(i)*100)*cos(i*2*PI/bsize);
    float y2 = (r + player.left.get(i)*100)*sin(i*2*PI/bsize);
    vertex(x2, y2);
    pushStyle();
    stroke(0);
    strokeWeight(3);
    point(x2, y2);
    popStyle();
  }
  endShape();
  noFill();
  noStroke();
  //in main draw, when a point's soundWave is not there anymore, we don't want the fill and stroke remain on the position. 

}


//void showMeta() {
//  int time =  meta.length();
//  textSize(50);
//  textAlign(CENTER);
//  text( (int)(time/1000-millis()/1000)/60 + ":"+ (time/1000-millis()/1000)%60, -7, 21);
//}

//boolean flag =false;
//void mousePressed() {
//  if (dist(mouseX, mouseY, width/2, height/2)<150) flag =!flag;
//}
//
////
boolean sketchFullScreen() {
  return true;
}

//void keyPressed() {
//  if(key==' ')exit();
//  if(key=='s')saveFrame("###.jpeg");
//}
}

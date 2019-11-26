import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;


/**
 * AISMA SoundMap by Kaitie Sly 
 An application created for IAT806 - an interactive map that visualizes and plays back
 inaudible and audible sounds recorded in Greater Victoria. 
 */


import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.core.*;
import de.fhpotsdam.unfolding.data.*;
import de.fhpotsdam.unfolding.events.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.interactions.*;
import de.fhpotsdam.unfolding.mapdisplay.*;
import de.fhpotsdam.unfolding.mapdisplay.shaders.*;
import de.fhpotsdam.unfolding.marker.*;
import de.fhpotsdam.unfolding.providers.*;
import de.fhpotsdam.unfolding.texture.*;
import de.fhpotsdam.unfolding.tiles.*;
import de.fhpotsdam.unfolding.ui.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.utils.*;

import java.util.*;
import java.io.BufferedWriter;
import java.io.FileWriter;


UnfoldingMap map;
PFont f; 
boolean displayInfo = false; 
// this is a vector to store all of the PointOfInterest objects 
Vector<PointOfInterest> points;
Vector<LocationInformation> info;
Minim minim;
double minDistance = Double.MAX_VALUE;
double currentDistance = 0;
float currentSoundVolume = 0;
PointOfInterest prevClosest;
PointOfInterest currentClosest;
Legend legend; 
static float SOUND_PLAYING_THRESHOLD = 25;
boolean locationInformationFlag = false;
int state = 0;

  //creates new point locations on the map using their lat/long coordinates
  Location airportLocation = new Location(48.645762, -123.416830);
  Location colwoodLocation = new Location(48.437749, -123.464147);
  Location schoolLocation = new Location(48.665729, -123.417807);
  Location highwayLocation = new Location(48.459857, -123.403194);
  Location myhouseLocation = new Location(48.428405, -123.401186);
  
  // creates marker objects using the location info from above
  SimplePointMarker airportMarker = new SimplePointMarker(airportLocation);
  SimplePointMarker colwoodMarker = new SimplePointMarker(colwoodLocation);
  SimplePointMarker schoolMarker = new SimplePointMarker(schoolLocation);
  SimplePointMarker highwayMarker = new SimplePointMarker(highwayLocation);
  SimplePointMarker myhouseMarker = new SimplePointMarker(myhouseLocation);


void setup() {
  size(displayWidth, displayHeight, P2D);
  //instantiates the Minim object
  minim = new Minim(this);
  f = createFont("Helvetica",16,true);
  //instantiates the UnfoldingMap object
  map = new UnfoldingMap(this, new EsriProvider.WorldGrayCanvas());

  //opens the map at the same location each time the sketch is run
  Location victoriaLocation = new Location (48.5f, -123.4f);
  map.zoomAndPanTo(victoriaLocation, 10);
  //restricts the map from moving more than 100km away from Victoria
  float maxPanningDistance = 100; //in km
  map.setPanningRestriction (victoriaLocation, maxPanningDistance);
  MapUtils.createDefaultEventDispatcher(this, map);
  
  
  points  = new Vector<PointOfInterest>();
  //PointOfInterest objects
  points.add(new PointOfInterest("sound1", airportLocation, minim, "airportLocation", 0));
  points.add(new PointOfInterest("sound2", colwoodLocation, minim, "colwoodLocation", 1));
  points.add(new PointOfInterest("sound3", schoolLocation, minim, "schoolLocation", 2));
  points.add(new PointOfInterest("sound4", highwayLocation, minim, "highwayLocation", 3));
  points.add(new PointOfInterest("sound5", myhouseLocation, minim, "myhouseLocation", 4));

  //sets the currentClosest point to the first point in the vector
  currentClosest = points.get(0);
  prevClosest = currentClosest;
 
 //new vector for the LocationInformation class objects
  info = new Vector<LocationInformation>();
  info.add(new LocationInformation("Sound Source: Airplanes", "Jan 27, 2019", "Victoria Airport", "airplane.jpg"));
  info.add(new LocationInformation("Sound Source: Construction Site", "Feb 28, 2019", "Belmont Road", "construction.jpg"));
  info.add(new LocationInformation("Sound Source: Mosquito Device", "Jan 27, 2019", "North Saanich Middle School", "mosquitodevice.jpg"));
  info.add(new LocationInformation("Sound Source: Highway Traffic Noise", "Feb 5, 2019", "Mackenzie Interchange", "traffic.jpg"));
  info.add(new LocationInformation("Sound Source: Tree Removal Service", "Nov 27, 2018", "936 Dunsmuir Road", "treeremoval.jpg"));
}

void draw() {
  PImage img; 
  map.draw(); 
  loadPixels();
  img = info.get(currentClosest.pointID).locationPhoto;

int detail=20;
color c;
for(int i=0;i<img.width;i+=2*detail){
  for(int j=0;j<img.height;j+=2*detail){
    c=img.get(i+ (int)detail/2,j+ (int)detail/2);
    noStroke();
    fill(c, 20);
    ellipse(i,j,detail,detail);
  }
}
// inverts the colors of the map
filter(INVERT);

 //displays the legend
 legend = new Legend("Legend:", "Infrasound color = green", "Ultrasound color = white", "Audible sound color = red", 
"Press the Enter key to toggle between." );
 legend.displayLegend();

    //this displays the information on the map based on the current closest point to the mouse
   if(map.getZoomLevel()>=10){
     map.addMarkers(airportMarker, colwoodMarker, schoolMarker, highwayMarker, myhouseMarker);
       info.get(currentClosest.pointID).displayInfo();
   }
   else{
       MarkerManager mar = map.getDefaultMarkerManager();
       mar.clearMarkers();
          MultiMarker mul = new MultiMarker();
          mul.addMarkers(airportMarker, colwoodMarker, schoolMarker, highwayMarker, myhouseMarker);
         map.addMarkers(mul);  
 }
 
  if(points.size() > 0){
    //if the size of the points is greater than zero then run the method below, which 
    //takes the current point and updates the current distance to the mouse with the mouse position
    //on the map 
    getMapLocation(map);
    
    for(int i=0; i<points.size(); i++){
      //display the soundWave for the corresponding point 
        points.get(i).displaySoundWave(map);
    }  
   }
}

class SortByDistance implements Comparator<PointOfInterest> 
{ 
    // Used for sorting in ascending order of 
    // roll number 
    public int compare(PointOfInterest a, PointOfInterest b) 
    { 
        if(a.distanceToMouse < b.distanceToMouse)
          return -1;
         else if(a.distanceToMouse > b.distanceToMouse)
           return 1;
          else 
            return 0;
    } 
}

public void getMapLocation(UnfoldingMap mapCPY) {
  //this gets the current lat and long coordinates of the mouse position on the map
  Location mousePositionOnMap = mapCPY.getLocation(mouseX, mouseY); 
  // this cycles through all the points (objects) in the vector
  for (int i=0; i<points.size(); i++){
    //this takes the current point and updates the current distance to the mouse with the mouse position
    //on the map that is calculated by the above
    points.get(i).updateDistanceToMouse(mousePositionOnMap);
    
  }
  
  //current distance from the mouse to a point is the distance to the mouse
  //of the current closest point to the mouse
    currentDistance = currentClosest.distanceToMouse;
    
    //the current sound volume is adjusted by the current distance of the mouse to 
    //a point
    currentSoundVolume = (SOUND_PLAYING_THRESHOLD - (float)currentDistance) / SOUND_PLAYING_THRESHOLD;
    //the gain is adjusted to decrease when the mouse moves away and increase as the mouse
    //moves closer
    //gain is set in dB -6 to 6
    currentClosest.player.setGain(-6  + (currentSoundVolume * 12));
  
    //sorts the points  
  Collections.sort(points, new SortByDistance());
  
  //if the first point in the vector is NOT the current closest point
  if(!points.get(0).locationName.equals(currentClosest.locationName)) {
    //the previous closest point becomes the current closest
    prevClosest = currentClosest;
    //the current closest gets put to the first index of the vector
    currentClosest = points.get(0);
    //the previous closest point's sound is stopped
    prevClosest.stopSound();
    //the current closest point plays the sound depending on the map zoom level
    currentClosest.playSound();    
  }
  
  //if the map zoom level is less than 10 (more zoomed out) then don't play the sound
  else if(mapCPY.getZoomLevel()<10){
     currentClosest.stopSound();
     //info.get(currentClosest.pointID).stopDisplayInfo(mapCPY); // doesn't work
  }
}

// this toggles between the different visualizations
void keyPressed(){
    if(key == ENTER){
      // calls the toggleState function in the PointOfInterest class on the current closest 
      //point to the mouse
      currentClosest.toggleState();
    }
   
}
//makes it fullscreen
boolean sketchFullScreen() {
  return true;
}


  


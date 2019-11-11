//creates a class that includes the soundfile and the location point in the constructor
class PointOfInterest {
  Location pointLocation = new Location(0, 0);
  String locationName = "test";
  double distanceToMouse = 0;
  AudioPlayer player;
  int pointID;
  Minim minim;
  SoundWave soundWave; 
  
  PointOfInterest(String filePath, Location pointLocation, Minim minim, String locationName, int myId) {
    this.pointLocation = pointLocation;
    this.minim = minim;
    this.pointID = myId;
    this.locationName = locationName;
    player = minim.loadFile(filePath);
    soundWave = new SoundWave(player);
  }
  
  void playSound(UnfoldingMap mapCPY) {
    //if the player is not playing, rewind the file and play it
     if(!player.isPlaying() && mapCPY.getZoomLevel()>9){
       player.rewind();
       player.play(); 
     } 
  }
  
  
  void stopSound() {
    //if the player is playing, stop the sound and rewind it
   if(player.isPlaying()){
     player.pause();
     player.rewind();
   } 
  }
  
  void updateDistanceToMouse(Location newMousePositionOnMap){
    distanceToMouse = pointLocation.getDistance(newMousePositionOnMap);
  }
  
  void displaySoundWave(UnfoldingMap mapCPY){
    //if its audio is playing, display SoundWave
    if (player.isPlaying()){
      ScreenPosition pos = mapCPY.getScreenPosition(pointLocation);
      soundWave.draw(pos.x, pos.y);
        // Add markers to the map
      mapCPY.addMarkers();
    } 
  }
}




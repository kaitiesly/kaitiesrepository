//creates a class that includes the soundfile and the location point in the constructor
class PointOfInterest {
  Location pointLocation = new Location(0, 0);
  String locationName = "test";
  double distanceToMouse = 0;
  AudioPlayer player;
  AudioPlayer InfraPlayer;
  AudioPlayer UltraPlayer;
  AudioPlayer currentPlayer;
  int pointID;
  Minim minim;
  SoundWave soundWave;
  int state = 0;
  
  PointOfInterest(String filePath, Location pointLocation, Minim minim, String locationName, int myId) {
    this.pointLocation = pointLocation;
    this.minim = minim;
    this.pointID = myId;
    this.locationName = locationName;
    player = minim.loadFile(filePath+".wav");
    InfraPlayer = minim.loadFile("infrasound"+filePath+".wav");
    UltraPlayer = minim.loadFile("ultrasound"+filePath+".wav");
    currentPlayer = player;
    soundWave = new SoundWave(currentPlayer);
  }
  
  void playSound() {
    //if the player is not playing, rewind the file and play it
     if(!currentPlayer.isPlaying()){
         currentPlayer.rewind();
         currentPlayer.play();   
     } 
  }
  
  
  void stopSound() {
    //if the player is playing, stop the sound and rewind it
   
   if(currentPlayer.isPlaying()){
     currentPlayer.pause();
     currentPlayer.rewind();
   }
  }
  
  void updateDistanceToMouse(Location newMousePositionOnMap){
    distanceToMouse = pointLocation.getDistance(newMousePositionOnMap);
  }
  
  void displaySoundWave(UnfoldingMap mapCPY){
    //if its audio is playing, display SoundWave
    if (currentPlayer.isPlaying()){
      ScreenPosition pos = mapCPY.getScreenPosition(pointLocation);
      soundWave.draw(pos.x, pos.y,currentPlayer, state);
        // Add markers to the map
      mapCPY.addMarkers();
    } 
  }
  
  // this makes the currentPlayer depend on which state is toggled. It will choose the normal
  // player, the InfraPlayer or the UltraPlayer depending on what is toggled. 
  void toggleState(){    
    state =(state+1)%3;
    stopSound();
    if(state == 0){
      currentPlayer = player; 
    }else if (state == 1){
      currentPlayer = InfraPlayer;
    }else if (state == 2){
      currentPlayer = UltraPlayer;
    }
    playSound();
  }
}




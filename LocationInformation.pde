class LocationInformation {
  
String locationDescription = "test";
String locationDate = "test";
PImage locationPhoto;
String locationName = "test";

 LocationInformation(String locationDescription, String locationDate, String locationName, 
 String filePath) {
    this.locationDescription = locationDescription;
    this.locationDate = locationDate;
    this.locationName = locationName;
    locationPhoto = loadImage(filePath);
    
  }
  
void displayInfo() {
 stroke(0);
  textFont(f,16);                 
  fill(255);                     
  text(locationDescription, width-280, height-60);
  text(locationDate, width-280, height-40);
  text(locationName, width-280, height-20);
  image(locationPhoto, width-460, height-130, locationPhoto.width/20, locationPhoto.height/20);
 }
 
 void stopDisplayInfo(UnfoldingMap mapCPY) {
   if(mapCPY.getZoomLevel()>9){
     locationDescription = "";
     locationDate = "";
     locationName = "";
     locationPhoto = null;
   }
     } 
 }


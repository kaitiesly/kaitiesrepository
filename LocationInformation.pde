class LocationInformation {
  
String locationDescription = "test";
String locationDate = "test";
PImage locationPhoto;
String locationName = "test";
int DETAIL_THRESHOLD = 20;
int detail = 15;

 LocationInformation(String locationDescription, String locationDate, String locationName, 
 String filePath) {
    this.locationDescription = locationDescription;
    this.locationDate = locationDate;
    this.locationName = locationName;
    locationPhoto = loadImage(filePath);
  }
  
void displayInfo() {
 stroke(0);
  textFont(f,12);                 
  fill(255);                     
  text(locationDescription, width-220, height-80);
  text(locationDate, width-220, height-60);
  text(locationName, width-220, height-40);
  //locationPhoto.filter(THRESHOLD);
  image(locationPhoto, width-340, height-100, locationPhoto.width/30, locationPhoto.height/30);
  
//  float z = 0; 
//  noStroke();
//    fill(0, 50);
//    rect(0,0,width,height);
//    stroke(255, 100);
//    //locationPhoto.resize(30,39);
//
//   for (float y = 0; y < height; y = y + 3) {
//       for (float x = 0; x < width; x = x + 1) {
//          
//      color c = locationPhoto.get(int(x),int(y));
//      stroke(c);
//      fill(c);
//      point(x-60, y + map(noise(x/150, y/150, z), 0, 1, -100, 100));
//        }
//    }
//      z = z + 0.02;
// 

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


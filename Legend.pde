class Legend {
  
  String legend;
  String infraColor;
  String ultraColor;
  String audibleColor;
  String enterKey;
  
  Legend (String legend, String infraColor, String ultraColor, String audibleColor, String enterKey) {
    this.legend = legend;
    this.infraColor = infraColor;
    this.ultraColor = ultraColor;
    this.audibleColor = audibleColor;
    this.enterKey = enterKey;
  }
  
  public void displayLegend(){
  // draws the legend
  fill(120, 118, 117, 150);
  noStroke();
  rect(30, height-120, 240, 100, 7);
  stroke(207, 205, 200);
  textFont(f,14);                 
  fill(207, 205, 200);                     
  text(legend, 40, height-100);
  stroke(0);
  textFont(f,12);                 
  fill(255, 179, 165);  
  text(audibleColor, 40, height-80);
  stroke(255);
  textFont(f,12);                 
  fill(255);
  text(ultraColor, 40, height-65);
  stroke(0);
  textFont(f,12);                 
  fill(165,255,255); 
  text(infraColor, 40, height-50);
  stroke(207, 205, 200);
  textFont(f,12);                 
  fill(207, 205, 200); 
  text(enterKey, 40, height-30);
 }
}

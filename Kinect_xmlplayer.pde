import proxml.*;
import processing.opengl.*;

int stageWidth = 640;
int stageHeight = 480;
int fps = 24;

int counter = 0;
int counterMax = 400;

proxml.XMLElement keyFrameList;
XMLInOut xmlIO;
boolean loaded = false;

String[] oscNames = {
  "r_hand","r_wrist","r_elbow","r_shoulder", "l_hand","l_wrist","l_elbow","l_shoulder","head","torso"
};
proxml.XMLElement[] oscXmlTags = new proxml.XMLElement [oscNames.length];

float[] x = new float[oscNames.length];
float[] y = new float[oscNames.length];
float[] z = new float[oscNames.length];
float depth = 200;
int circleSize = 50;

void setup() {
  size(stageWidth,stageHeight,OPENGL);
  frameRate(fps);

  xmlIO = new XMLInOut(this);
  try {
    xmlIO.loadElement("mocapData.xml"); //loads the XML
  }
  catch(Exception e) {
    //if loading failed 
    println("Loading Failed");
  }
  ellipseMode(CENTER);
}

void xmlEvent(proxml.XMLElement element) {
  //this function is ccalled by default when an XML object is loaded
  keyFrameList = element;
  //parseXML(); //appelle la fonction qui analyse le fichier XML
  loaded = true;
}


void draw() {
  background(0);
  if(loaded){
  parseXML();
  fill(255,200);
  stroke(0);
  strokeWeight(5);
  for(int i=0;i<oscNames.length;i++) {
    pushMatrix();
    translate(width*x[i],height*y[i],(-depth*z[i])+abs(depth/2));
    ellipse(0,0,circleSize,circleSize);
    popMatrix();
  }
  if(counter<counterMax) {
    counter++;
  } 
  else {
    counter=0;
  }
}
}

void parseXML(){
  if(counter<counterMax){
    for(int i=1;i<oscXmlTags.length;i++) { // i=1 because 0 is the frame number
    String posXs, posYs, posZs;
    float posX, posY, posZ;
    oscXmlTags[i] = keyFrameList.getChild(counter).getChild(i); //gets to the child we need
    //loops through all the children that interest us
    posXs = oscXmlTags[i].getChild(0).firstChild().toString(); //gets the title
    posYs = oscXmlTags[i].getChild(1).firstChild().toString(); //gets the URL link
    posZs = oscXmlTags[i].getChild(2).firstChild().toString(); //gets the description
    posX = float(posXs);
    posY = float(posYs);
    posZ = float(posZs);
    //add the data to the 2D array
    x[i] = posX;
    y[i] = posY;
    z[i] = posZ;
    println(keyFrameList.getChild(counter).getChild(0).firstChild() + " " + oscXmlTags[i] + " " + posX + " " + posY + " " + posZ);
  }
  }
}

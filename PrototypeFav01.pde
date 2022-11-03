import processing.sound.*;

AudioIn input;
Amplitude analyzer;

float phase = 0;
float modi;
float noiseMax;
float modScale;
float modScaleModifier;
color[] colors = {#ff595e,#ff924c,#ffca3a,#c5ca30,#8ac926,#36949d,#1982c4,#4267ac,#565aa0,#6a4c93};

void setup() {
  size(1080, 1920);
  strokeWeight(1); 
  noFill();

  input = new AudioIn(this, 0);
  input.start();
  analyzer = new Amplitude(this);
  analyzer.input(input);
}

void draw() {
  background(5);
  noiseMax = 3; // Smoothness of the curve
  //modScale = 1*map(analyzer.analyze(),0,1,0,500); // Height of the curve
  modScale = 25*map(analyzer.analyze(),0,1,1,35); // Height of the curve
  modScaleModifier = 1.5; // Change of heigth between curves
  float addphase = map(analyzer.analyze(),0,1,0.01,0.06);

  // Curve drawing
  for (int i=0;i<10;i+=1) {
    stroke(colors[i]);
    beginShape();
    for (float a=0; a<height; a+=1) {
      if(a<(height/2)){
        modi=a;
      }else{
        modi=(height/2)-(a-height/2);
      }
      float xoff = map(cos(a/100),-1,1,0,noiseMax);
      float yoff = map(sin(a/100),-1,1,0,noiseMax);
      float heightmin = map(modi,0,height/2,width/2,width/2-modScale);
      float heightmax = map(modi,0,height/2,width/2,width/2+modScale);
      float r = map(noise(xoff, yoff, phase),0,1,heightmin,heightmax);
      float y = a;
      float x = r;
      curveVertex(x,y);
    }
    endShape();
    modScale = modScale/modScaleModifier;
  }
  if (phase > 100000000) {
    phase = 0;
  }
  phase += addphase;
}

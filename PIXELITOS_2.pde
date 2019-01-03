import SimpleOpenNI.*;  //kinect
import java.util.*; 
import oscP5.*;  //osc
import netP5.*;  //osc

SimpleOpenNI context; 

OscP5 oscP5;
NetAddress puerto;

OPC opc;
int cols = 16;
int fils = 12;
int anchoCelda;
int altoCelda;

////ZONAS
Hotspot zona1;
Hotspot zona2;
Hotspot zona3;

Grid grid;

color colorSilueta;
float c;
int dir = 1;

////r g b
color Ro = color(255, 0, 0);
color Ve = color(0, 255, 0);
color Az = color(0, 0, 255);


////mezcla 
color Am = color(255, 200, 0);
color Cy = color(0, 255, 255);
color Ma = color(255, 0, 255);

////COLOR POR USUARIO
/*color[] userColors = {
 color(255, 75, 252), 
 color(50, 250, 255), 
 color(150, 230, 20), 
 color(255, 130, 0)
 };*/


int[] userMap;
int userCurID;

void setup() {
  size(640, 480);
  //size(1280, 960);
  //colorMode(HSB,360,100,100);

  ////OSC
  oscP5 = new OscP5(this, 8000);
  puerto = new NetAddress("127.0.0.1", 8000);

  ////opc
  anchoCelda = width/cols;
  altoCelda = height/fils;
  opc = new OPC(this, "127.0.0.1", 7890);
  opc.ledStrip(0, 12, (width/17+2) -0, height/2, height / 12.0, PI/2, true);
  opc.ledStrip(12, 12, (width/17*2+4) - 0, height/2, height / 12.0, PI/2, false);
  opc.ledStrip(24, 12, (width/17*3+4) - 0, height/2, height / 12.0, PI/2, true);
  opc.ledStrip(36, 12, (width/17*4+4) - 0, height/2, height / 12.0, PI/2, false);
  opc.ledStrip(48, 12, (width/17*5+4) - 0, height/2, height / 12.0, PI/2, true);
  opc.ledStrip(60, 12, (width/17*6+4) - 0, height/2, height / 12.0, PI/2, false);
  opc.ledStrip(72, 12, (width/17*7+4) - 0, height/2, height / 12.0, PI/2, true);
  opc.ledStrip(84, 12, (width/17*8+4) - 0, height/2, height / 12.0, PI/2, false);
  opc.ledStrip(96, 12, (width/17*9+4) - 0, height/2, height / 12.0, PI/2, true);
  opc.ledStrip(108, 12, (width/17*10+4) - 0, height/2, height / 12.0, PI/2, false);
  opc.ledStrip(120, 12, (width/17*11+4) - 0, height/2, height / 12.0, PI/2, true);
  opc.ledStrip(132, 12, (width/17*12+4) - 0, height/2, height / 12.0, PI/2, false);
  opc.ledStrip(144, 12, (width/17*13+4) - 0, height/2, height / 12.0, PI/2, true);
  opc.ledStrip(156, 12, (width/17*14+4) - 0, height/2, height / 12.0, PI/2, false);
  opc.ledStrip(168, 12, (width/17*15+4) - 0, height/2, height / 12.0, PI/2, true);
  opc.ledStrip(180, 12, (width/17*16+4) - 0, height/2, height / 12.0, PI/2, false);
  //opc.ledStrip(180, 12, (width/17*17) - 0, height/2, height / 12.0, PI/2, true);




  ////grid
  grid = new Grid(); 

  ////kinect
  context = new SimpleOpenNI(this);
  context.setMirror(true);   /// Flip horizontal
  context.enableDepth();
  context.enableUser();
  //context.enableRGB(); ///RGB CAM
  // blob_array=new int[cont_length];//no se que es

  //zonas - Hotspot(limXA, limXB; limYA, limYB, color)
  zona1 = new Hotspot(-150, 250, 2200, 2700, color(Ro));
  zona2 = new Hotspot(350, 650, 2200, 2700, color(Ve)); 
  zona3 = new Hotspot(750, 1050, 2200, 2700, color(Az));
}



void draw() {

  //scale(2);
  background(0);
  context.update();

  int[]depthValues= context.depthMap();
  int[] userMap = null;
  int userCount = context.getNumberOfUsers();

  OscMessage volLive = new OscMessage("/live/vol");

  if (userCount > 0) {
    userMap = context.userMap();
    volLive.add(90);
    oscP5.send(volLive, puerto);
  }
  // mientras no haya usuario hacer funcion de animacion con reticula y parar live
  if (userCount <= 0) {
    grid.dibujar(1);
    volLive.add(0);
    oscP5.send(volLive, puerto);
  }

  loadPixels();

  //image(context.rgbImage(), 0, 0);

  for (int y=0; y<context.depthHeight (); y+=40) {
    for (int x=0; x<context.depthWidth (); x+=37) {

      int index = x + y * context.depthWidth();

      if (userMap != null && userMap[index] > 0) {
      //int colorIndex = userMap[index] % userColors.length;
        userCurID = userMap[index];
        // blob_array[index] = 255;


        PVector position = new PVector();
        context.getCoM(userCurID, position);
         
        //println(position.x, position.z);

        context.startTrackingSkeleton(userCurID);
        // if ( context.isTrackingSkeleton(userCurID)) {
        PVector pieDer = new PVector();////pie der
        context.getJointPositionSkeleton(userCurID, SimpleOpenNI.SKEL_RIGHT_FOOT, pieDer);
        PVector pieIzq = new PVector();////pie izq
        context.getJointPositionSkeleton(userCurID, SimpleOpenNI.SKEL_LEFT_FOOT, pieIzq);
        //}
        ////MAPEO ZONAS
        //r
        if (zona1.esTocada(pieIzq.x, pieIzq.z) && zona1.esTocada(pieDer.x, pieDer.z)) { // if(zona1.esTocada(pieDer.x, pieDer.z)
          colorSilueta = zona1.col;
        } 
        //g
        else if (zona2.esTocada(pieIzq.x, pieIzq.z) && zona2.esTocada(pieDer.x, pieDer.z)) {
          colorSilueta = zona2.col;
        } 
        //b
        else if (zona3.esTocada(pieIzq.x, pieIzq.z) && zona3.esTocada(pieDer.x, pieDer.z)) {
          colorSilueta = zona3.col;
        } 
        //am
        else if (zona1.esTocada(pieIzq.x, pieIzq.z) && zona2.esTocada(pieDer.x, pieDer.z)) {
          colorSilueta = color(Am);
        } 
        //Cyan
        else if (zona2.esTocada(pieIzq.x, pieIzq.z) && zona3.esTocada(pieDer.x, pieDer.z)) {
          colorSilueta = color(Cy);
        }
        //magenta
        else if (zona1.esTocada(pieIzq.x, pieIzq.z) && zona3.esTocada(pieDer.x, pieDer.z)) {
          colorSilueta = color(Ma);
        }
        else {
//if (userCurID == 1)
          // ciclos2();
colorSilueta = color(c, 255, 255);
//colorSilueta = userColors[colorIndex];
        }


        //FORMA COLOR SILUETA USUARIO
        //color usericon=userColors[colorIndex];
        // fill(usericon);
        ciclos(0.1); //me toca llamarla en el for, por q ?
        //ciclos2();
        //noStroke();
        fill(colorSilueta);
        rect(x, y, 40, 40);
      } else {
        //blob_array[index]=0; //// que es ?
      }
    }
  }//for



  //// track mano der u1
  PVector manoDer = new PVector();
  context.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_RIGHT_HAND, manoDer);

  PVector manoIzq = new PVector();
  context.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_LEFT_HAND, manoIzq);

  //mapeo pos mano a rangos de una octava
  int manoDermap = (int)map(manoDer.y, 0, 1000, 0, 127);
  //int manoDermap = (int)map(manoDer.y, 0, 1000, 60, 71);
  manoDermap = constrain(manoDermap, 0, 127);

  int manoIzqmap = (int)map(manoIzq.y, 0, 1000, 0, 127);
  manoIzqmap = constrain(manoIzqmap, 0, 127);


  ////OSC
  OscMessage myMessage = new OscMessage("/manos/izq");
  //OscMessage myMessage2 = new OscMessage("/manos/der");
  myMessage.add(manoDermap); 
  myMessage.add(manoIzqmap);
  oscP5.send(myMessage, puerto);


//// track mano der u2
  PVector manoDer2 = new PVector();
  context.getJointPositionSkeleton(2, SimpleOpenNI.SKEL_RIGHT_HAND, manoDer2);

  PVector manoIzq2 = new PVector();
  context.getJointPositionSkeleton(2, SimpleOpenNI.SKEL_LEFT_HAND, manoIzq2);

  //mapeo pos mano a rangos de una octava
  int manoDermap2 = (int)map(manoDer2.y, 0, 1000, 0, 127);
  //int manoDermap = (int)map(manoDer.y, 0, 1000, 60, 71);
  manoDermap2 = constrain(manoDermap2, 0, 127);

  int manoIzqmap2 = (int)map(manoIzq2.y, 0, 1000, 0, 127);
  manoIzqmap2 = constrain(manoIzqmap2, 0, 127);


  ////OSC
  OscMessage myMessage2 = new OscMessage("/manos_u2");
  //OscMessage myMessage2 = new OscMessage("/manos/der");
  myMessage2.add(manoDermap2); 
  myMessage2.add(manoIzqmap2);
  oscP5.send(myMessage2, puerto);
println(userCurID);
  // println(manoIzq.y);
}


///COLORES ciclos
void ciclos(float factor) {
  colorMode(HSB);
  c = c + dir * factor;
  if  ((c >= 255) || (c < 0)) {
    dir = dir * -1;
    // if (frameCount % 15 == 0) {
    //println(c);
  }  
  // c++;
}
void ciclos2() {
  colorMode(HSB);
  if  (c >= 255) {
    c = 0;
  } else {
    c++;
  }
}

/// Print info de usuario / no se está llamando en draw
void onNewUser(int userId) {
  println("detected" + userId);
}
void onLostUser(int userId) {
  println("lost: " + userId);
}


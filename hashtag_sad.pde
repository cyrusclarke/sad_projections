import processing.video.*;

import deadpixel.keystone.*;

Keystone ks; // the keystone object
Keystone ks1; // the keystone object
Keystone ks2; // the keystone object
CornerPinSurface surface; // this is the surface
CornerPinSurface surface1; // this is the surface
CornerPinSurface surface2; // this is the surface
Movie mov; // this will hold the movie
Movie mov1; // this will hold the movie
Movie mov2; // this will hold the movie
boolean isPlaying = false;
PGraphics offscreen; // the offsceen buffer
PGraphics offscreen1; // the offsceen buffer
PGraphics offscreen2; // the offsceen buffer


void setup() {
  // Keystone will only work with P3D or OPENGL renderers, 
  // since it relies on texture mapping to deform
  size(1270, 720, P3D);

  ks = new Keystone(this); // init the keystoen object
  ks1 = new Keystone(this); // init the keystoen object
  ks2 = new Keystone(this); // init the keystoen object
  surface = ks.createCornerPinSurface(400, 400, 20); // create the surface
  surface1 = ks1.createCornerPinSurface(300, 300, 20); // create the surface
  surface2 = ks1.createCornerPinSurface(500, 500, 20); // create the surface  
  mov = new Movie(this, "art1.mp4" ); // load the video
  mov1 = new Movie(this, "art2.mp4" ); // load the video
  mov2 = new Movie(this, "art3.mp4" ); // load the video
  mov.frameRate(25); // set the framerate
  mov1.frameRate(25); // set the framerate
  mov2.frameRate(25); // set the framerate
  // We need an offscreen buffer to draw the surface we
  // want projected
  // note that we're matching the resolution of the
  // CornerPinSurface.
  // (The offscreen buffer can be P2D or P3D)
  offscreen = createGraphics(500, 500, P3D);
  mov.play();// we need to start the movie once
  mov.jump(0);// go to the first frame
  mov.pause(); // and hold it until we hit p
  mov.loop();
  offscreen1 = createGraphics(500, 500, P3D);
  mov1.play();
  mov1.jump(0);// go to the first frame
  mov1.pause(); // and hold it until we hit p
  mov1.loop();
  offscreen2 = createGraphics(500, 500, P3D);
  mov2.play();
  mov2.jump(0);// go to the first frame
  mov2.pause(); // and hold it until we hit p
  mov2.loop();
  

}

void draw() {

  // Draw the scene, offscreen
  offscreen.beginDraw(); // start writing into the buffer
  offscreen.background(0);
  offscreen.image(mov, 0, 0); // <-- here we add the current frame to the buffer
  offscreen.endDraw(); // we are done 'recording'
//video 2
  offscreen1.beginDraw(); // start writing into the buffer
  offscreen1.background(0);
  offscreen1.image(mov1, 0, 0); // <-- here we add the current frame to the buffer
  offscreen1.endDraw(); // we are done 'recording'
//video 3
  offscreen2.beginDraw(); // start writing into the buffer
  offscreen2.background(0);
  offscreen2.image(mov2, 0, 0); // <-- here we add the current frame to the buffer
  offscreen2.endDraw(); // we are done 'recording'

  // most likely, you'll want a black background to minimize
  // bleeding around your projection area
  background(0);
  // this is for resetting the video after it was played. 
  //video 0
  if (mov.time() == mov.duration()) {
    mov.jump(0);
  }
  surface.render(offscreen);// add everything to the surface
//video 1
  if (mov1.time() == mov1.duration()) {
    mov1.jump(0);
  }
  surface1.render(offscreen1);// add everything to the surface
//video 2
  if (mov2.time() == mov2.duration()) {
    mov2.jump(0);
  }
  surface2.render(offscreen2);// add everything to the surface
}


void keyPressed() {
  switch(key) {
  case 'c':
    // enter/leave calibration mode, where surfaces can be warped 
    // and moved
    ks.toggleCalibration();
    break;

  case 'l':
    // loads the saved layout
    ks.load();
    break;

  case 's':
    // saves the layout
    ks.save();
    break;
  case 'p':
    // play/pause the movie on keypress
    if (isPlaying == false) {
      mov.play();
      isPlaying = true;
    } else {
      mov.pause();
      isPlaying = false;
    }
    break;
  }
}

void movieEvent(Movie m) {
  m.read();
}
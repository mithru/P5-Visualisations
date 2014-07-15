import controlP5.*;
ControlP5 cp5;

boolean cp5_toggle = true;

Table acc, gyr;

PShape[] acc_val = new PShape[3];
PShape[] gyr_val = new PShape[3];

float scale_factor = 1.05;
float data_magnification = 1.1;
int granularity = 12;

float speed = 1;

int anim_count = 0;

void setup() {
  size(displayWidth, displayHeight, P2D);
  //  background(0);

  println(displayWidth + " " + displayHeight);

  cp5 = new ControlP5(this);

  cp5.addSlider("granularity")
    .setPosition(20, displayHeight - 50 )
      .setSize(200, 20)
        .setRange(1, 20)
          .setValue(12)
            .setVisible(cp5_toggle);
  ;

  cp5.addSlider("scale_factor")
    .setPosition(displayWidth/4, displayHeight - 50 )
      .setSize(200, 20)
        .setRange(5, 0.1)
          .setValue(1.05)
            .setVisible(cp5_toggle);
  ;

  cp5.addSlider("data_magnification")
    .setPosition(displayWidth/2, displayHeight - 50 )
      .setSize(200, 20)
        .setRange(0.1, 2)
          .setValue(1.1)
            .setVisible(cp5_toggle);
  ;

  cp5.addSlider("speed")
    .setPosition(displayWidth*3/4, displayHeight - 50 )
      .setSize(200, 20)
        .setRange(0, 50)
          .setValue(10)
            .setVisible(cp5_toggle);
  ;

  cp5.addBang("reset")
    .setPosition(displayWidth - 70, displayHeight - 50 )
      .setSize(20, 20)
        .setTriggerEvent(Bang.RELEASE)
          .setLabel("reset")
            ;


  acc = loadTable("acc.csv");
  gyr = loadTable("gyr.csv");

  //  println(acc.getRowCount() + " rows");
  //  println(acc.getColumnCount() + " columns");
  reset();
  update(anim_count);
}


void draw() {

  //  saveFrame("video/screencapture-#######.png");
  update(anim_count);
  delay(1);
  anim_count += speed;
  if (anim_count > displayWidth)
    anim_count = displayWidth;

  //  background(0);
//  pushMatrix();
//  scale(1.3);
//  image(bg, 0, 0);
//  popMatrix();

  pushMatrix();
//  scale(0.4);
  fill(0,127);
  noStroke();
  rect(0, 0, displayWidth, displayHeight);
  shape(acc_val[2], 0, displayHeight/3);
  shape(acc_val[1], 0, displayHeight/3);
  shape(acc_val[0], 0, displayHeight/3);

  shape(gyr_val[2], 0, displayHeight * 2/3);
  shape(gyr_val[1], 0, displayHeight * 2/3);
  shape(gyr_val[0], 0, displayHeight * 2/3);

  popMatrix();

  if (cp5_toggle) {
    cp5.show();
  } 
  else cp5.hide();
}

void keyReleased() {
  switch(key) {
  case 'd': 
    cp5_toggle = !cp5_toggle;
    break;
  case 's': 
    saveFrame("video/screencapture-#######.png");
    break;

  case 'r':
    reset();
    break;
  }
}


void update(int anim_count) {
  for (int i = 0; i < 3; i++ ) {
    acc_val[i] = new PShape();
    acc_val[i] = createShape();
    acc_val[i].beginShape();
    acc_val[i].noStroke();
    acc_val[i].fill(255, i * 70, 0);


    gyr_val[i] = new PShape();
    gyr_val[i] = createShape();
    gyr_val[i].beginShape();
    gyr_val[i].noStroke();
    gyr_val[i].fill(0, 127 + i * 63, 143 );

    float acc_subtractor = 0;
    float gyr_subtractor = 0;


    acc_val[i].vertex(0, 0);
    gyr_val[i].vertex(0, 0);

    int index_count = min(anim_count, acc.getRowCount(), gyr.getRowCount());

    for (int j = 3; j < index_count; j+=granularity) {
      if (i > 0) {
        acc_subtractor = (acc.getInt(j, i+1) * data_magnification);
        gyr_subtractor = (gyr.getInt(j, i+1) * data_magnification);
      }
      acc_val[i].vertex((j - 3) / scale_factor, ( - acc_subtractor - ((acc.getInt(j, i+2)) * data_magnification)));
      gyr_val[i].vertex((j - 3) / scale_factor, ( - gyr_subtractor - ((gyr.getInt(j, i+2)) * data_magnification)));
    }

    acc_val[i].vertex(min(anim_count, acc.getRowCount()) / scale_factor, 0);
    gyr_val[i].vertex(min(anim_count, gyr.getRowCount()) / scale_factor, 0);

    acc_val[i].endShape();
    gyr_val[i].endShape();
  }
}

void reset() {
  anim_count = 0;
}

boolean fullScreen = true;

boolean sketchFullScreen() {
  if (fullScreen) {
    return true;
  } 
  else return false;
}


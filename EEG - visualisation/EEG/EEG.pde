import controlP5.*;
ControlP5 cp5;

Table eeg_data;

PShape shape;

boolean play = false;

float degree = 0;
int curr_data_point;
int values_per_electrode_per_frame = 10;
int num_of_electrodes = 14; 
float data_points_per_frame = (values_per_electrode_per_frame * num_of_electrodes);
float degree_step = 360 / data_points_per_frame;

Point[] point = new Point[int(data_points_per_frame)];

color[] c = new color[num_of_electrodes];

void setup() {

  size(displayWidth, displayHeight);
  shape = createShape();

  cp5 = new ControlP5(this);
  cp5.addSlider("curr_data_point")
    .setPosition(0, 0 )
      .setSize(displayWidth - 1, 20)
        .setRange(0, 14999 - values_per_electrode_per_frame)
          .setValue(0)
            ;


  cp5.addBang("play")
    .setPosition(0, 40 )
      .setSize(40, 40)
        .setTriggerEvent(Bang.RELEASE)
          ;

  colorMode(HSB);
  smooth();

  for (int i = 0; i < point.length; i++) {
    point[i] = new Point();
  }

  eeg_data = loadTable("sample_csv.csv");
}

void draw() {
  fill(0, 100);
  noStroke();
  background(0);
  //  rect(0, 0, displayWidth, displayHeight);
  pushMatrix();
  translate(displayWidth/2, displayHeight/2);
  //  scale(0.1);
  //  fill(255);

  for (int step = 0; step < point.length; step++) {
    float data = map(eeg_data.getFloat(int(curr_data_point + step % values_per_electrode_per_frame), int(step / values_per_electrode_per_frame)), 3000, 5000, 300, 500) - 250;
    float x = cos(radians(step * degree_step)) * data;
    float y = sin(radians(step * degree_step)) * data;

    point[step].setPosition(x, y);
    point[step].setSize(2);
    point[step].setColor(color(step/data_points_per_frame * 255, 255, 100));
    stroke(color(step/data_points_per_frame * 255, 255, 100));
    strokeWeight(2);
    line(x, y, x*2, y*2);
    //    point[step].display();
  }

  //  shape.beginShape();
  //  int prev_step = point.length - 1;

  for (int step = 0; step < point.length; step++) {
    //    stroke(color(step/data_points_per_frame * 255, 255, 100));
    //    line(point[prev_step].x, point[prev_step].y, point[step].x, point[step].y);
    //    prev_step = step;
    //    shape.vertex(point[step].x, point[step].y);
  }

  //  shape.endShape();
  //  
  //  shape.fill(100);
  //  shape(shape);

  popMatrix();

  println(curr_data_point);

  //  delay(1);
  if (play == true) {
    curr_data_point++;
    curr_data_point = curr_data_point % 14950;
  }

  stroke(255);
  strokeWeight(1);
  line(map(curr_data_point, 0, 14999, 0, displayWidth), 0, map(curr_data_point, 20, 14999, 0, displayWidth), 25);
  fill(255);
  textSize(10);
  text(curr_data_point, map(curr_data_point, 0, 14999, 0, displayWidth), 30);
}

void play() {
  play = !play;
}


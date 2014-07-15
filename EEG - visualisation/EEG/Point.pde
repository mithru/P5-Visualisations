class Point {
  float x, y;
  float size;
  color col;

  Point() {
    x = 0;
    y = 0;
    size = 1;
    col = color(127, 0, 255);
  }  

  Point(float x, float y) {
    this.x = x;
    this.y = y;
    size = 1;
    col = color(127, 0, 255);
  }

  void setColor(color c) {
    col = c;
    fill(c);
  }

  void setPosition(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void setSize(float s) {
    this.size = s;
  }

  void display() {
    ellipse(x, y, size, size);
  }
}


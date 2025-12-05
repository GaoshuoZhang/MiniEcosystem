class Slider {
  //slider position and size
  float x, y;     //top-left of slider track
  float w, h;     //width and height of the track

  //value range
  float minVal = 0;
  float maxVal = 100;

  //vurrent value
  private float value = 0;

  //internal state for dragging
  private boolean dragging = false;
  private float knobRadius;
  private float knobX, knobY;

  // Constructor: specify track rectangle
  Slider(float x_, float y_, float w_, float h_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;

    //knob is a circle
    knobRadius = h;
    updateKnobPosition();
  }

  //call each frame to handle mouse interaction
  void update() {
    //start dragging
    if (mousePressed && overKnob()) {
      dragging = true;
    }
    //stop dragging
    if (!mousePressed) {
      dragging = false;
    }

    //if dragging, update value according to mouseX
    if (dragging) {
      float pct = (mouseX - x) / w;
      pct = constrain(pct, 0, 1);
      value = lerp(minVal, maxVal, pct);
      updateKnobPosition();
    }
  }

  //draw slider track and knob
 void display() {
  //draw track
  stroke(150);
  strokeWeight(2);
  line(x, y + h/2, x + w, y + h/2);

  //draw knob
  noStroke();
  fill(200);
  ellipse(knobX, knobY, knobRadius, knobRadius);

  //draw label
  fill(0);
  textAlign(CENTER, BOTTOM);
  textSize(15);
  text("Factory Overload: " + nf(value, 1, 1) + "%", x + w/2, y - 5);

  //draw animal icons
  int iconSize = 30;
  float spacing = 15;
  float iconY = 450;

  for (int i = 0; i < 4; i++) {
    float iconX = 20 + spacing * i + iconSize * i;
    PImage icon = null;
    if (i == 0) icon = cowIcon;
    if (i == 1) icon = sheepIcon;
    if (i == 2) icon = rabbitIcon;
    if (i == 3) icon = wolfIcon;
    image(icon, iconX, iconY, iconSize, iconSize);
  }
}


  //return current slider value (0–100)
  float getValue() {
    return value;
  }

  //set the slider to a given value programmatically
  void setValue(float v) {
    value = constrain(v, minVal, maxVal);
    updateKnobPosition();
  }

  //check if mouse is over the knob
  private boolean overKnob() {
    float dx = mouseX - knobX;
    float dy = mouseY - knobY;
    return (dx*dx + dy*dy) <= (knobRadius/2)*(knobRadius/2);
  }

  //update knobX/knobY based on current value
  private void updateKnobPosition() {
    float pct = (value - minVal) / (maxVal - minVal);
    knobX = x + pct * w;
    knobY = y + h/2;
  }
}

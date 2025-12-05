class Factory {
  PImage img;
  PVector pos;
  Slider slider;
  float power; //current power
  float emissionLevel = 0; //to control acid rain concentration

  //list of stored exhaust gas particles
  ArrayList<SmogParticle> smogParticles = new ArrayList<SmogParticle>();

  Factory(PVector position, Slider sliderRef) {
    img = loadImage("data/factory.png");
    pos = position.copy();
    slider = sliderRef;
  }

  void update() {
    //get overload
    power = slider.getValue(); 
    float targetEmission = constrain(power / 100.0, 0, 1);
    emissionLevel = lerp(emissionLevel, targetEmission, 1);

    //if the factory is on, new exhaust particles are created
    if (emissionLevel > 0) {
      smogParticles.add(new SmogParticle(pos.x + 135, pos.y - 20));
    }

    //update and remove outdated exhaust particles
    for (int i = smogParticles.size() - 1; i >= 0; i--) {
      SmogParticle p = smogParticles.get(i);
      p.update();
      if (p.alpha <= 0 | p.pos.x > width) {
        smogParticles.remove(i);
      }
    }
  }

  void display() {
    image(img, pos.x, pos.y, 150, 150);

    //display exhaust
    for (SmogParticle p : smogParticles) {
      p.display();
    }
  }

  float getPower() {
    return power;
  }

  float getEmissionLevel() {
    return emissionLevel;
  }

  //exhaust
  class SmogParticle {
    PVector pos;
    PVector velocity;
    float alpha;

    SmogParticle(float x, float y) {
      pos = new PVector(x, y);
      //gogogogo upupup right
      velocity = new PVector(random(0.1, 1), random(-2, -1)); 
      alpha = 255;
    }

    void update() {
      pos.add(velocity);

      //prevent exhaust fumes from drifting outside the canvas and damaging my computer
      if (pos.y < 10) {
        pos.y = random(10);
        pos.x += random(5);
      }

      //disappear
      alpha -= 0.5;
      alpha = constrain(alpha, 0, 255); 
    }

    void display() {
      //change color
      int smokeColor = lerpColor(color(255), color(0), emissionLevel);
      fill(smokeColor, alpha);
      noStroke();
      ellipse(pos.x, pos.y, 20, 20);
    }
  }
}

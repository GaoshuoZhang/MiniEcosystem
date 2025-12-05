class Raindrop {
  PVector pos;
  float speed;
  PImage img;

  Raindrop(float x, float y, float speed, PImage img) {
    this.pos = new PVector(x, y);
    this.speed = speed;
    this.img = img;
  }

  void update() {
    pos.y += speed;
  }

  void display() {
    image(img, pos.x, pos.y, 15, 15);
  }

  boolean isOffScreen() {
    return pos.y > height;
  }
}

class Rain {
  Timer timer;
  Factory factory;
  float acidConcentration = 0;

  PImage rainImg1, rainImg2, rainImg3, rainImg4;
  PImage currentRainImg;

  ArrayList<Raindrop> drops = new ArrayList<Raindrop>();
  int spawnInterval = 100;
  int lastSpawnTime = 0;

  Rain(Timer timer, Factory factory) {
    this.timer = timer;
    this.factory = factory;

    rainImg1 = loadImage("data/water.png");
    rainImg2 = loadImage("data/water2.png");
    rainImg3 = loadImage("data/water3.png");
    rainImg4 = loadImage("data/water4.png");

    currentRainImg = rainImg1;
  }

  void update() {
    timer.update();
    float target = factory.getEmissionLevel();  // 0–1
    acidConcentration = lerp(acidConcentration, target, 0.01);

    float percent = acidConcentration * 100;
    if (percent < 25) {
      currentRainImg = rainImg1;
    } else if (percent < 50) {
      currentRainImg = rainImg2;
    } else if (percent < 75) {
      currentRainImg = rainImg3;
    } else {
      currentRainImg = rainImg4;
    }

    if (timer.isRaining() && millis() - lastSpawnTime > spawnInterval) {
      for (int i = 0; i < 10; i++) {
        float x = random(260, width);
        float y = random(-20, 0);
        float speed = random(4, 7);
        drops.add(new Raindrop(x, y, speed, currentRainImg));
      }
      lastSpawnTime = millis();
    }

    //update all water
    for (int i = drops.size() - 1; i >= 0; i--) {
      Raindrop d = drops.get(i);
      d.update();
      if (d.isOffScreen()) {
        drops.remove(i);
      }
    }
  }

  void display() {
    for (Raindrop d : drops) {
      d.display();
    }
  }

  float getAcidConcentration() {
    return acidConcentration;
  }
}

class Grass {
  PVector pos;

  Grass(PVector pos) {
    this.pos = pos.copy();
  }
}

class GrassManager {
  ArrayList<Grass> grasses;
  Rain rain;
  PImage grassImg;

  final int maxGrass = 300;//max number of gurass
  final float SIZE = 20;//grass size

  int lastSpawnTime = 0;

  GrassManager(ArrayList<Grass> grasses, Rain rain) {
    this.grasses = grasses;
    this.rain = rain;
    grassImg = loadImage("data/grass.png");
  }

  void update() {
    float acid = rain.getAcidConcentration();

    if (grasses.size() >= maxGrass) return;

    //grass growth interval
    //The higher the acid rain concentration, the longer the interval
    int interval = int(lerp(1, 300, acid));  
    int now = millis();
    if (now - lastSpawnTime >= interval) {
      float x = random(260, width - SIZE);
      float y = random(SIZE/2, height - SIZE/2);
      grasses.add(new Grass(new PVector(x, y)));
      grasses.add(new Grass(new PVector(x, y)));
      lastSpawnTime = now;
    }
  }

  void display() {
    for (Grass g : grasses) {
      image(grassImg, g.pos.x - SIZE / 2, g.pos.y - SIZE / 2, SIZE, SIZE);
    }
  }

  int getMaxGrassCount() {
    return maxGrass;
  }

  int getCurrentGrassCount() {
    return grasses.size();
  }
}

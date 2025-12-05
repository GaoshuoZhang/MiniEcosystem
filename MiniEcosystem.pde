ArrayList<Grass> grasses;
ArrayList<Herbivore> herbivores;
ArrayList<Carnivore> carnivores;
PImage cowIcon, sheepIcon, rabbitIcon, wolfIcon;

Factory factory;
Slider slider;
Timer timer;
Rain rain;
GrassManager grassManager;

void setup() {
  size(1280, 720);
  frameRate(60);
  cowIcon = loadImage("data/cow.png");
  sheepIcon = loadImage("data/sheep.png");
  rabbitIcon = loadImage("data/rabbit.png");
  wolfIcon = loadImage("data/wolf.png");

  //initializer
  grasses     = new ArrayList<Grass>();
  herbivores  = new ArrayList<Herbivore>();
  carnivores  = new ArrayList<Carnivore>();
  ArrayList<PVector> occupied = new ArrayList<PVector>();


  //initialize slider and factory
  slider  = new Slider(25, 400, 150, 20);
  factory = new Factory(new PVector(20, 200), slider);

  //initialize timer and rain
  timer = new Timer();
  rain  = new Rain(timer, factory);

  //initialize grass
  grassManager = new GrassManager(grasses, rain);

  //initialize Herbivore
  for (int i = 0; i < 5; i++) {
    PVector pos = randomFreePosition(occupied, 40);
    herbivores.add(new Cow(pos, grasses, herbivores, carnivores));
  }
  for (int i = 0; i < 5; i++) {
    PVector pos = randomFreePosition(occupied, 40);
    herbivores.add(new Sheep(pos, grasses, herbivores, carnivores));
  }
  for (int i = 0; i < 5; i++) {
    PVector pos = randomFreePosition(occupied, 40);
    herbivores.add(new Rabbit(pos, grasses, herbivores, carnivores));
  }

  //initialize Carnivore
  for (int i = 0; i < 3; i++) {
    PVector pos = randomFreePosition(occupied, 40);
    carnivores.add(new Wolf(pos, herbivores, carnivores));
  }
}

void draw() {
  background(#87ceeb);

  //grassland
  noStroke();
  fill(#bca26e);
  rect(250, 0, width - 250, height);

  //road
  fill(100);
  rect(200, 0, 50, height);
  stroke(200);
  strokeWeight(2);
  for (float y = 0; y < height; y += 40) {
    line(225, y, 225, y + 20);
  }

  //slider and factory
  slider.update();
  slider.display();

  factory.update();
  factory.display();


  //grass
  grassManager.update();
  grassManager.display();

  //herbivores
  for (int i = herbivores.size() - 1; i >= 0; i--) {
    Herbivore h = herbivores.get(i);
    h.update();
    h.display();
    if (h.dead) {
      herbivores.remove(i);
    }
  }

  //carnivores
  for (int i = carnivores.size() - 1; i >= 0; i--) {
    Carnivore c = carnivores.get(i);
    c.update();
    c.display();
    if (c.dead) {
      carnivores.remove(i);
    }
  }

  //timer and rain
  timer.update();
  rain.update();
  rain.display();

  //show info
  int cowCount = 0;
  int sheepCount = 0;
  int rabbitCount = 0;
  int wolfCount = 0;

  for (Herbivore h : herbivores) {
    if (h instanceof Cow) cowCount++;
    else if (h instanceof Sheep) sheepCount++;
    else if (h instanceof Rabbit) rabbitCount++;
  }

  for (Carnivore c : carnivores) {
    if (c instanceof Wolf) wolfCount++;
  }

  int grassCount = grasses.size();
  int maxGrass = grassManager.getMaxGrassCount();
  float acid = rain.getAcidConcentration();


  fill(0);
  textSize(20);
  textAlign(LEFT, TOP);
  if (timer.timeUntilRain() / 1000 != 0){
    text("\nTime: " + (timer.currentTime/1000) + "s" + "\nNext rain: " + (timer.timeUntilRain() / 1000) + "s", 10, 0);
  }else if(timer.timeUntilRain() / 1000 == 0){
    text("\nTime: " + (timer.currentTime/1000) + "s" + "\nRainning! ", 10, 0);
  }
  
  textAlign(LEFT, BOTTOM);
  text(
    "Cows: " + cowCount +
    "\nSheep: " + sheepCount +
    "\nRabbits: " + rabbitCount +
    "\nWolves: " + wolfCount +
    "\nGrass: " + grassCount + "/" + maxGrass +
    "\nAcid: " + nf(acid, 0, 2),
    10, height - 10
    );
}

void mousePressed() {
  float spacing = 15;
  float iconY = 450;
  for (int i = 0; i < 4; i++) {
    float iconX = 20 + spacing * i + 30 * i;
    if (mouseX > iconX && mouseX < iconX + 30 && mouseY > iconY && mouseY < iconY + 30) {
      PVector spawnPos = new PVector(random(260, width), random(height));
      if (i == 0) herbivores.add(new Cow(spawnPos, grasses, herbivores, carnivores));
      if (i == 1) herbivores.add(new Sheep(spawnPos, grasses, herbivores, carnivores));
      if (i == 2) herbivores.add(new Rabbit(spawnPos, grasses, herbivores, carnivores));
      if (i == 3 && carnivores.size() < 15) carnivores.add(new Wolf(spawnPos, herbivores, carnivores));
    }
  }
}


//prevent overlapping animals
PVector randomFreePosition(ArrayList<PVector> existing, float minDist) {
  PVector p;
  boolean ok;
  do {
    p = new PVector(random(260, width - 40), random(20, height - 40));
    ok = true;
    for (PVector o : existing) {
      if (PVector.dist(p, o) < minDist) {
        ok = false;
        break;
      }
    }
  } while (!ok);
  existing.add(p);
  return p;
}

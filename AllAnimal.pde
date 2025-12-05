//Cow
class Cow extends Herbivore {
  Cow(PVector startPos, ArrayList<Grass> grasses, ArrayList<Herbivore> herd, ArrayList<Carnivore> carnivores) {
    super(
      startPos,
      random(2.6,2.7),//speed
      100,//vision
      50,//hunger
      loadImage("data/cow.png"),
      random(20,27),//grass to satisfy hunger when eat
      grasses,
      herd, carnivores
    );
  }
    Herbivore createOffspring(PVector pos) {
    return new Cow(pos.copy(), grasses, herd, carnivores);
  }
}

//Sheep
class Sheep extends Herbivore {
  Sheep(PVector startPos, ArrayList<Grass> grasses, ArrayList<Herbivore> herd, ArrayList<Carnivore> carnivores) {
    super(
      startPos,
      random(2.6,2.7),//speed
      90,//vision
      50,//hunger
      loadImage("data/sheep.png"),
      random(20,30),//grass to satisfy hunger when eat
      grasses,
      herd, carnivores
    );
  }
  Herbivore createOffspring(PVector pos) {
    return new Sheep(pos.copy(), grasses, herd, carnivores);
  }
}


//Rabbit
class Rabbit extends Herbivore {
  Rabbit(PVector startPos, ArrayList<Grass> grasses, ArrayList<Herbivore> herd, ArrayList<Carnivore> carnivores) {
    super(
      startPos,
      random(2.6,2.7),//speed
      80,//vision
      50,//hunger
      loadImage("data/rabbit.png"),
      random(20,30),//grass to satisfy hunger when eat
      grasses,
      herd, carnivores
    );
  }
  Herbivore createOffspring(PVector pos) {
    return new Rabbit(pos.copy(), grasses, herd, carnivores);
  }
}


//Wolf
class Wolf extends Carnivore {
  Wolf(PVector startPos, ArrayList<Herbivore> preyList, ArrayList<Carnivore> pack) {
    super(
      startPos,
      random(2.9,3.2),//speed
      400,//vision
      50,//hunger
      loadImage("data/wolf.png"),
      preyList,
      pack
    );
  }
    Carnivore createOffspring(PVector pos) {
    return new Wolf(pos.copy(), prey, pack);
  }
}

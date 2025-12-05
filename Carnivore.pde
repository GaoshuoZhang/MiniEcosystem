class Carnivore extends Animal {
  PImage img;
  ArrayList<Herbivore> prey;
  ArrayList<Carnivore> pack;

  final float GAIN = 20;//hunger value reduced when eating food
  final float SIZE = 40;
  final float COLLISION_DIST = 20;
  final float SEPARATION_STRENGTH = 0.5;
  final float REPRO_THRESHOLD = 80;
  final int REPRO_COOLDOWN = 10000; 
  final int MAX_AGE = 60000; 
  final int MAX_CARNIVORES = 15;
  final int EAT_PAUSE = 100;

  int lastReproduceTime = 0;
  int lastEatTime = -EAT_PAUSE;
  int birthTime;

  Herbivore currentTarget = null;  //current target

  Carnivore(PVector p, float sp, float vis, float hunger0,
    PImage img, ArrayList<Herbivore> prey, ArrayList<Carnivore> pack) {
    super(p, sp, vis, hunger0);
    this.img = img;
    this.prey = prey;
    this.pack = pack;
    this.birthTime = millis();
  }

  void update() {
    int now = millis();

    //check age
    if (now - birthTime > MAX_AGE) {
      pack.remove(this);
      return;
    }

    hunger -= 0.05;

    //check can eat
    if (now - lastEatTime < EAT_PAUSE) return;

    //check can reproduce
    if (hunger > REPRO_THRESHOLD && now - lastReproduceTime > REPRO_COOLDOWN) {
      Carnivore mateTarget = null;
      float bestMateDist = Float.MAX_VALUE;

      for (Carnivore other : pack) {
        if (other != this &&
          other.getClass() == this.getClass() &&
          other.hunger > REPRO_THRESHOLD &&
          now - other.lastReproduceTime > REPRO_COOLDOWN) {
          float d = distanceTo(other.pos);
          if (d < bestMateDist) {
            bestMateDist = d;
            mateTarget = other;
          }
        }
      }

      if (mateTarget != null && bestMateDist > COLLISION_DIST) {
        moveToward(mateTarget.pos);
        return;
      } else if (mateTarget != null && bestMateDist <= COLLISION_DIST) {
        if (pack.size() < MAX_CARNIVORES) {
          PVector childPos = pos.copy().add(random(-SIZE, SIZE), random(-SIZE, SIZE));
          Carnivore baby = createOffspring(childPos);
          pack.add(baby);
        }

        hunger -= 50;
        mateTarget.hunger -= 50;
        lastReproduceTime = now;
        mateTarget.lastReproduceTime = now;
        return;
      } else {
        wanderWithReducedSpeed();
        return;
      }
    }

    //check can hunte
    if (currentTarget != null && prey.contains(currentTarget)) {
      float d = distanceTo(currentTarget.pos);
      if (d > COLLISION_DIST) {
        moveToward(currentTarget.pos);
      } else {
        prey.remove(currentTarget);
        hunger += GAIN;
        lastEatTime = now;
        currentTarget = null; 
      }
    } else {
      currentTarget = findMostAbundantTarget();
      if (currentTarget != null) {
        moveToward(currentTarget.pos);
      } else {
        wander();
      }
    }

    //avoid overlap
    for (Carnivore other : pack) {
      if (other != this) {
        float d = distanceTo(other.pos);
        if (d > 0 && d < SIZE) {
          PVector push = PVector.sub(pos, other.pos).normalize().mult(SEPARATION_STRENGTH);
          pos.add(push);
        }
      }
    }

    checkBounds();
    checkDeathByHunger();
  }

  //prioritize the largest number of prey
  Herbivore findMostAbundantTarget() {
    //count
    int cowCount = 0, sheepCount = 0, rabbitCount = 0;
    for (Herbivore h : prey) {
      if (h instanceof Cow) cowCount++;
      else if (h instanceof Sheep) sheepCount++;
      else if (h instanceof Rabbit) rabbitCount++;
    }

    //find the largest
    Class targetClass = Cow.class;
    if (sheepCount > cowCount && sheepCount >= rabbitCount) targetClass = Sheep.class;
    else if (rabbitCount > cowCount && rabbitCount > sheepCount) targetClass = Rabbit.class;

    Herbivore best = null;
    float bestD = Float.MAX_VALUE;
    for (Herbivore h : prey) {
      if (h.getClass() == targetClass) {
        float d = distanceTo(h.pos);
        if (d < bestD && d <= vision) {
          bestD = d;
          best = h;
        }
      }
    }
    return best;
  }

  void wanderWithReducedSpeed() {
    PVector dir = PVector.random2D();
    dir.mult(speed * 0.5);
    pos.add(dir);
  }

  void display() {
    image(img, pos.x - SIZE / 2, pos.y - SIZE / 2, SIZE, SIZE);
  }

  Carnivore createOffspring(PVector pos) {
    return new Carnivore(pos, speed, vision, hunger / 2, img, prey, pack);
  }

  void checkBounds() {
    if (pos.x < 260) pos.x = 260;
    if (pos.x > width) pos.x = width;
    if (pos.y < 0) pos.y = 0;
    if (pos.y > height) pos.y = height;
  }
}

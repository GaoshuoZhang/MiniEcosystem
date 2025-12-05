class Herbivore extends Animal {
  PImage img;
  float gain;
  ArrayList<Grass> grasses;
  ArrayList<Herbivore> herd;
  ArrayList<Carnivore> predators;

  final float REPRO_THRESHOLD = 80;
  final float SIZE = 40;
  final float COLLISION_DIST = 20;
  final float SEPARATION_STRENGTH = 0.5;
  final int REPRO_COOLDOWN = 5000;
  final int MAX_HERBIVORES = 200;
  final float FLEE_DISTANCE = random(60, 100);
  int lastReproduceTime = 0;

  Herbivore(PVector p, float sp, float vis, float hunger0,
            PImage img, float gain,
            ArrayList<Grass> grasses,
            ArrayList<Herbivore> herd,
            ArrayList<Carnivore> predators) {
    super(p, sp, vis, hunger0);
    this.img = img;
    this.gain = gain;
    this.grasses = grasses;
    this.herd = herd;
    this.predators = predators;
  }

  void update() {
    hunger -= 0.05;
    int now = millis();

    //flee
    PVector fleeDir = new PVector(0, 0);
    boolean shouldFlee = false;

    for (Carnivore predator : predators) {
      float d = distanceTo(predator.pos);
      if (d < FLEE_DISTANCE) {
        PVector away = PVector.sub(pos, predator.pos);
        fleeDir.add(away);
        shouldFlee = true;
      }
    }

    if (shouldFlee) {
      fleeDir.normalize().mult(speed);
      pos.add(fleeDir);
    } else {
      //reproduction
      boolean canReproduce = (herd.size() < MAX_HERBIVORES) &&
                             (hunger > REPRO_THRESHOLD) &&
                             (now - lastReproduceTime > REPRO_COOLDOWN);

      Herbivore mateTarget = null;
      float bestMateDist = Float.MAX_VALUE;

      if (canReproduce) {
        for (Herbivore other : herd) {
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
      }

      if (mateTarget != null && bestMateDist > COLLISION_DIST) {
        moveToward(mateTarget.pos);
      } else if (mateTarget != null && bestMateDist <= COLLISION_DIST) {
        PVector childPos = pos.copy().add(random(-SIZE, SIZE), random(-SIZE, SIZE));
        Herbivore baby = createOffspring(childPos);
        herd.add(baby);

        hunger -= 50;
        mateTarget.hunger -= 50;
        lastReproduceTime = now;
        mateTarget.lastReproduceTime = now;
      } else {
        //eat
        if (hunger > 90) {
          //can not eat
          wander();
        } else {
          Grass target = null;
          float bestD = Float.MAX_VALUE;
          for (Grass g : grasses) {
            float d = distanceTo(g.pos);
            if (d < bestD) {
              bestD = d;
              target = g;
            }
          }
          if (target != null) {
            if (bestD > COLLISION_DIST) {
              moveToward(target.pos);
            } else {
              grasses.remove(target);
              hunger += gain;
            }
          } else {
            wander();
          }
        }
      }
    }

    //prevent overlap
    for (Herbivore other : herd) {
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

  void display() {
    image(img, pos.x - SIZE / 2, pos.y - SIZE / 2, SIZE, SIZE);
  }

  Herbivore createOffspring(PVector pos) {
    return new Herbivore(pos, speed, vision, hunger / 2, img, gain, grasses, herd, predators);
  }

  void checkBounds() {
    if (pos.x < 260) pos.x = 260;
    if (pos.x > width) pos.x = width;
    if (pos.y < 0) pos.y = 0;
    if (pos.y > height) pos.y = height;
  }

  void checkDeathByHunger() {
    if (hunger <= 0) {
      for (int i = 0; i < random(3); i++) {
        float offsetX = random(-30, 30);
        float offsetY = random(-30, 30);
        PVector grassPos = pos.copy().add(offsetX, offsetY);

        if (grassPos.x < 260) grassPos.x = 260;
        if (grassPos.x > width) grassPos.x = width;
        if (grassPos.y < 0) grassPos.y = 0;
        if (grassPos.y > height) grassPos.y = height;

        if (grasses.size() < 200) {
          grasses.add(new Grass(grassPos));
        }
      }

      herd.remove(this);
    }
  }
}

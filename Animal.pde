abstract class Animal {
  PVector pos;  //current position
  PVector vel;  //current velocity
  float hunger;  //current hunger
  float speed;  //movement speed
  float vision;  //vision
  boolean dead = false;
  boolean hasReproduced = false;
  
  Animal(PVector startPos, float startSpeed, float startVision, float startHunger) {
    pos = startPos.copy();
    vel = PVector.random2D().mult(startSpeed);
    speed = startSpeed;
    vision = startVision;
    hunger = startHunger;
  }

  abstract void update();

  abstract void display();


  void moveToward(PVector target) {
    PVector desired = PVector.sub(target, pos);
    float d = desired.mag();
    if (d > 0.1) {
      desired.normalize();
      desired.mult(speed);
      vel = desired;
    }
    pos.add(vel);
    checkBounds();
  }

  void wander() {
    //jitter velocity direction slightly
    PVector jitter = PVector.random2D().mult(0.1 * speed);
    vel.add(jitter);
    vel.limit(speed);
    pos.add(vel);
    checkBounds();
  }

  void checkBounds() {
    if (pos.x < 0) {
      pos.x = 0;
      vel.x *= -1;
    }
    if (pos.x > width) {
      pos.x = width;
      vel.x *= -1;
    }
    if (pos.y < 0) {
      pos.y = 0;
      vel.y *= -1;
    }
    if (pos.y > height) {
      pos.y = height;
      vel.y *= -1;
    }
  }


  float distanceTo(PVector target) {
    return PVector.dist(pos, target);
  }


  boolean sees(Animal other) {
    return distanceTo(other.pos) <= vision;
  }


  void die() {
    dead = true;
  }

  void checkDeathByHunger() {
    if (hunger <= 0) {
      die();
    }
  }
}

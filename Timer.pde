class Timer {
  //time between rain starts and duration of each rain
  int rainInterval = 20000;   // 20s
  int rainDuration = 5000;    // 5s
  int currentTime;

  //timestamp of the last transition
  int lastTransition = 0;
  //whether it's currently raining
  boolean raining = false;

  //initialize the timer
  Timer() {
    lastTransition = millis();
  }

  //call once per frame to update rain state
  void update() {
    currentTime = millis();

    if (raining) {
      //if raining, check if duration has elapsed
      if (currentTime >= lastTransition + rainDuration) {
        raining = false;
        // Mark end transition to schedule next rain after full interval
        lastTransition = currentTime;
      }
    } else {
      //if not raining, check if it's time to start a new rain
      if (currentTime >= lastTransition + rainInterval) {
        raining = true;
        //mark start rain
        lastTransition = currentTime;
      }
    }
  }

  //returns true if it's raining right now
  boolean isRaining() {
    return raining;
  }

  //returns how many milliseconds remain until rain starts
  int timeUntilRain() {
    if (raining) return 0;
    int elapsed = millis() - lastTransition;
    return max(rainInterval - elapsed, 0);
  }

  //returns how many milliseconds remain until rain ends
  int timeUntilStop() {
    if (!raining) return 0;
    int elapsed = millis() - lastTransition;
    return max(rainDuration - elapsed, 0);
  }
}

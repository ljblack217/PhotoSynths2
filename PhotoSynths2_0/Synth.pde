class Synth {
  ArrayList<Knuckle> branches;
  PVector center, velocity, acceleration;
  Synth(float x, float y, int knuckleMax) {
    center = new PVector(x, y);
    int knStart = int(random(3)+3);
    branches = new ArrayList<Knuckle>();
    for (int s = 0; s<knStart; s++) {
      branches.add(new Knuckle(radians(((360/knStart)*s)+random(45)), knuckleMax, center, 0));
    }
    println(branches.size());
  }
  void updateSynth(float inlight) {
    for (Knuckle current : branches) {
      current.update(inlight, center, current.angle);
    }
  }
  void drawSynth() {
    if (branches.size()>0) {
      for (Knuckle drawing : branches) {
        drawing.drawKnuckle();
      }
    }
  }
}

class Knuckle {
  float angle, vAng, vAcc, gAng;
  float len;
  boolean branching;
  int max;
  PVector start, end, endAcc; 
  ArrayList<Knuckle> children;
  Knuckle(float startAngle, int inMax, PVector pLoc, float b) {
    itemCount ++;
    len = 0;
    gAng = b;
    max = inMax-1;
    start = pLoc;
    end = new PVector();
    angle = startAngle + gAng;
    children = new ArrayList<Knuckle>();
  }
  void update(float light, PVector in, float inAngle) {

    start = in;

    end.x = start.x + cos(angle) * len;
    end.y = start.y + sin(angle) * len;
    println(start.x, end.x, start.y, end.y);
    if (len<maxLength) {
      //print(len);
      len += light;
    } else if (max>0) {
      if (children.size()==0) {
        children.add(new Knuckle(angle, max, end, 0));
      }
      if (random(5000/max) < light*2 && itemCount<150) {
        if (children.size()<2) {
          float bAngle;
          if (coin()) {
            bAngle = radians(random(20, 75));
          } else {
            bAngle = -radians(random(20, 75));
          }
          children.add(new Knuckle(angle, max, end, bAngle));
        }
      }
    }


    if (children.size()>0) {
      for (Knuckle child : children) {
        child.update(light, end, angle);
      }
    }
  }
  void drawKnuckle() {
    fill(255);
    stroke(0);
    line(end.x, end.y, start.x, start.y);
    ellipse(end.x, end.y, 20, 20);
    fill(0);


    if (children.size()>0) {
      for (Knuckle child : children) {
        child.drawKnuckle();
      }
    }
  }
}

int N = 200;
ArrayList<Bird> flock;

void setup(){
  size(800,800);
  flock = new ArrayList<Bird>();
  for(int i=0; i<N; i++){
    Bird b = new Bird();
    flock.add(b);
  }
  
  fill(255);
  noStroke();
  strokeWeight(1);
}

void draw(){
  background(0);
  
  for(Bird b : flock){
    b.flockBehaviours(flock);
    b.update();
    b.show();
  }
}

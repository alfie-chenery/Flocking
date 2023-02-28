class Bird{
  PVector pos;
  PVector vel;
  PVector acc;
  
  int alignPerceptionRadius = 50;
  int cohesionPerceptionRadius = 50;
  int seperationPerceptionRadius = 50;
  float maxAlign = 0.1;
  float maxCohesion = 0.2;
  float maxSeperation = 0.2;
  float maxSpeed = 3;
  
  Bird(){
    pos = new PVector(random(width), random(height));
    vel = PVector.random2D().setMag(random(1,10));
    acc = new PVector();;
  }
  
  void flockBehaviours(ArrayList<Bird> flock){
    PVector alignment = align(flock);
    PVector cohesion = cohesion(flock);
    PVector seperation = seperation(flock);
    acc.add(alignment);
    acc.add(cohesion);
    acc.add(seperation);
  }
  
  void update(){
    screenWrap();
    pos.add(vel);
    vel.add(acc);
    vel.limit(maxSpeed);
    acc.mult(0);
  }
  
  void show(){
    //point(pos.x,pos.y);
    
    PVector facing = vel.copy();
    PVector facingPerp = new PVector(-facing.y, facing.x);
    facing.setMag(15);
    facingPerp.setMag(5);
    PVector vertex1 = new PVector(pos.x + facing.x, pos.y + facing.y);
    PVector vertex2 = new PVector(pos.x + facingPerp.x, pos.y + facingPerp.y);
    PVector vertex3 = new PVector(pos.x - facingPerp.x, pos.y - facingPerp.y);
    triangle(vertex1.x, vertex1.y, vertex2.x, vertex2.y, vertex3.x, vertex3.y);
   
  }
  
  void screenWrap(){
    if(pos.x > width){
      pos.x = 0; 
    } else if(pos.x < 0){
      pos.x = width;
    }
    if(pos.y > height){
      pos.y = 0; 
    } else if(pos.y < 0){
      pos.y = height;
    }    
    
  }
  
  PVector align(ArrayList<Bird> locals){ //try to match average velocity (direction)
    PVector avg = new PVector();
    int total = 0;
    
    for(Bird other : locals){
      float d = PVector.dist(pos, other.pos);
      if(other != this && d < alignPerceptionRadius){
        avg.add(other.vel); 
        total++;
      }
    }
    if(total > 0){
      avg.div(total);
      avg.setMag(maxSpeed); //desired velocity is average direction at maxSpeed
      PVector steer = PVector.sub(avg, vel); //desired - cur vel
      steer.limit(maxAlign);
      return steer;
    }
    return new PVector(); //if no locals dont steer -> steer force = (0,0)
  }
  
  PVector cohesion(ArrayList<Bird> locals){ //try to match average position (go to centre)
    PVector avg = new PVector();
    int total = 0;
    
    for(Bird other : locals){
      float d = PVector.dist(pos, other.pos);
      if(other != this && d < cohesionPerceptionRadius){
        avg.add(other.pos); 
        total++;
      }
    }
    if(total > 0){
      avg.div(total);
      PVector desired = PVector.sub(avg, pos); 
      desired.setMag(maxSpeed); //desired velocity is towards centre at maxSpeed
      PVector steer = PVector.sub(desired, vel);
      steer.limit(maxCohesion);
      return steer;
    }
    return new PVector(); //if no locals dont steer -> steer force = (0,0)
  }
  
  PVector seperation(ArrayList<Bird> locals){ //move to avoid crowding locals
    PVector avg = new PVector();
    int total = 0;
    
    for(Bird other : locals){
      float d = PVector.dist(pos, other.pos);
      if(other != this && d < seperationPerceptionRadius){
        PVector diff = PVector.sub(pos, other.pos);
        diff.setMag(1/d); //inversely proportional to distance
        avg.add(diff);
        total++;
      }
    }
    if(total > 0){
      avg.div(total);
      avg.setMag(maxSpeed); //desired velocity is average direction away at maxSpeed
      PVector steer = PVector.sub(avg, vel);
      steer.limit(maxSeperation);
      return steer;
    }
    return new PVector(); //if no locals dont steer -> steer force = (0,0)
  }
  
}

class Bullet
{
  float x, y;
  float r=50;
  float vel=4;
  PVector direction;
  
  Bullet(float x,float y, float r, float vel, PVector dir)
  {
    this.x=x;
    this.y=y;
    this.r=r;
    this.vel=vel;
    direction=dir;
  }
  Bullet()
  {
    init();
  }
  Bullet(float x, float y,PVector dir)
  {
    this.x=x;
    this.y=y;
    direction=dir;
  }
  
  void init()
  {
    int i=round(random(1,4));
    switch(i)
    {
      case 1:
        x=random(0,width);
        y=-r;
        break;
      case 2:
        x=-r;
        y=random(0,height);
        break;
      case 3:
        x=width+r;
        y=random(0,height);
        break;
      case 4:
        x=random(0,width);
        y=height+r;
        break;
    }
    direction=PVector.random2D();
  }
  
  void move()
  {
    x+=direction.x*vel;
    y+=direction.y*vel;
    
    x=min(width+r,max(-r,x));
    y=min(height+r,max(-r,y));
    
    if(x==-r|| y==-r || x==width+r || y==height+r)
      init();
  }
  void display()
  {
    fill(0);
    ellipse(x,y,r,r);
  }
}
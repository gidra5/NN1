class Player implements Comparable<Player>
{
  NeuralNetwork nn;
  float x,y;
  float r=8;
  float vel=8;
  PVector dir=new PVector();
  boolean dead=true;
  int birth;
  int score=-1,maxScore;
  color col=color(255);
  int dN=16;
  int[] neuronsPerLayer={dN+2,2}; //структура нейронки
  
  Player()
  {
    nn=new NeuralNetwork(neuronsPerLayer);
  }
  
  int compareTo(Player p) //используется в Arrays.sort()
  {
    return p.score-score; //если счёт
    //у опонента больше - ты ниже в массиве  
  }
  
  void display()
  {
    noStroke();
    fill(col);
    ellipse(x,y,r,r);
    stroke(1);
  }
  
  void spawn()
  {
    if(dead)
    {
      birth=frameCount;
      x=width/2;
      y=height/2;
      dead=false;
      
      evolve();
    }
  }
  
  void spawn(Player base)
  {
    if(dead)
    {
      col=color(0,255,0);
      birth=frameCount;
      x=width/2;
      y=height/2;
      dead=false;
      
      evolve(base);
    }
  }
  
  void getInfo(Bullet[] bullets)
  {
    nn.initInput();
    for(Bullet b: bullets)
    {
      float dx=b.x-x,dy=b.y-y,
            dist=sq(dx)+sq(dy)-sq(b.r+r)/4,
            maxDist=sq(height)+sq(width)-sq(b.r+r)/4,
            q=dist/maxDist;
      
      if(dist<0)
      {                           //хорошее место
        dead=true;                //что бы проверить попадание
        score=frameCount-birth;   
        maxScore=max(maxScore,score);
        return;
      }
      
      for(int j=0;j< dN;++j)
      {
        float a=cos(TWO_PI*j/dN)*dx+sin(TWO_PI*j/dN)*dy;
        if((q<nn.input[j] || nn.input[j]==0) 
           && abs(cos(TWO_PI*j/dN)*dy-sin(TWO_PI*j/dN)*dx)<b.r
           && a>0)
        {
          //8 направлений, для каждой пули
          //проверяем расстояние до соответствующей прямой
          //и в том ли направлени она находится,
          //что и направление, что проверяется
          
          nn.input[j]=(1-q);
        }
      }
    }
    nn.input[dN]=2*x/width-1;
    nn.input[dN+1]=2*y/height-1;
    //nn.input[10]=memory;
  }
  
  void think(Bullet[] bullets)
  {
    getInfo(bullets);
    
    if(!dead)
    {
      float[] data=nn.umph();
      
      dir.x=data[0];//data[1]*cos(TWO_PI*data[0]);//data[0]-data[1];
      dir.y=data[1];//data[1]*sin(TWO_PI*data[0]);//data[2]-data[3];
      dir.x/=sqrt(sq(data[1])+sq(data[0]));
      dir.y/=sqrt(sq(data[1])+sq(data[0]));
      
      //memory=memory*0.3+0.7*data[2];
    }
  }
  
  void move()
  {
    x+=dir.x*vel;
    y+=dir.y*vel;
    
    x=min(width,max(0,x));
    y=min(height,max(0,y));
    
    if(x==0 || y==0 || x==width || y==height)
    {
      dead=true;                
      score=frameCount-birth;
      maxScore=max(maxScore,score);
    }
  }
  
  void evolve(Player base)
  { /*
    for(int i=0;i<nn.layersN;++i)
      for(int j=0;j<nn.layers[i].neuronsN;++j)
      {
        for(int k=0;k<nn.layers[i].neurons[j].weightsN;++k)
          nn.layers[i].neurons[j].weights[k]
          =base.nn.layers[i].neurons[j].weights[k]+base.nn.layers[i].neurons[j].dw[k];
          
        nn.layers[i].neurons[j].bias
        =base.nn.layers[i].neurons[j].bias+base.nn.layers[i].neurons[j].db;
      }*/
    
    
    for(int i=0;i<nn.layersN;++i)
      for(int j=0;j<nn.layers[i].neuronsN;++j)
      {
        for(int k=0;k<nn.layers[i].neurons[j].weightsN;++k)
          nn.layers[i].neurons[j].weights[k]
          =base.nn.layers[i].neurons[j].weights[k]+10*random(-1,1)*(maxScore-averageInGen)/(maxScore+base.score);
          
        nn.layers[i].neurons[j].bias
        =base.nn.layers[i].neurons[j].bias+10*random(-1,1)*(maxScore-averageInGen)/(base.score+maxScore);
      }
  }
  
  void evolve()
  {
    if(col==color(255))
        nn.randomInit();
    else if(col==color(254))
      for(int i=0;i<nn.layersN;++i)
        for(int j=0;j<nn.layers[i].neuronsN;++j)
        {
          for(int k=0;k<nn.layers[i].neurons[j].weightsN;++k)
            nn.layers[i].neurons[j].weights[k]=
            nn.layers[i].neurons[j].weights[k]*random(-1.5,1.5)
            +random(1,15);
            
          nn.layers[i].neurons[j].bias=
          nn.layers[i].neurons[j].bias*random(-1.5,1.5)
          +random(1,15);
        }
    else if(col==color(0,0,255) || col==color(0,255,0))
    //он лучший или он уже изменён
      return;
    else if(col==color(255,0,0))
    {
      for(int i=0;i<nn.layersN;++i)
        for(int j=0;j<nn.layers[i].neuronsN;++j)
        {
          for(int k=0;k<nn.layers[i].neurons[j].weightsN;++k)
            nn.layers[i].neurons[j].weights[k]+=random(-1,1)*0.01;
            
          nn.layers[i].neurons[j].bias+=random(-1,1)*0.01;
        }
    }
  }
}

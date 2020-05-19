import java.util.*;

Bullet[] bullets=new Bullet[20];
DisplayNeuralNetwork dnn;
int playersN=50;
int generation=0; 
int maxScore=1,maxScoreInGen;
float averageInGen=2,average=1;

Player[] players=new Player[playersN];

void setup()
{
  fullScreen();
  ellipseMode(CENTER);
  for(int i=0;i<bullets.length;++i)
    bullets[i]=new Bullet();
  for(int i=0;i<playersN;++i)
  {
    players[i]=new Player();
    players[i].nn.randomInit();
    players[i].spawn();
  }
  dnn=new DisplayNeuralNetwork(players[0].nn,450,50);
  textSize(20);
}

void draw()
{
  background(127);
  
  for(int i=0;i<bullets.length;++i)
  {
    bullets[i].move();
    bullets[i].display();
  }
  
  boolean everyoneDead=true;
  int j=0;
  for(int i=0;i<playersN;++i)
  {
    Player p=players[i];
    if(!p.dead)        //если не мёртв, то
    {
      p.display();
      p.think(bullets);//думаем
      p.move();        //и двигаемся
      j=i;
    }
    everyoneDead =
    everyoneDead && p.dead; 
  }
  
  players[j].col=color(255,0,255);
  dnn=new DisplayNeuralNetwork(players[j].nn,450,50);
  
  if(everyoneDead) //если все мертвы
  {
    ++generation;  //создается новое поколение
    
    for(int i=0;i<bullets.length;++i)
    bullets[i]=new Bullet();  //пересоздаем пули
    
    Arrays.sort(players); //сортировка по счёту
    
    float c=0;
    for(int i=0;i<playersN;++i)
    {
      Player p=players[i];
      c+=p.score;
      if(i<round(0.05*playersN))
        p.col=color(0,0,255);
      else if(i<round(0.1*playersN))
        p.col=color(255,0,0);
      else //if(i<round(0.8*playersN))
      {
        p.spawn(players[i%round(0.1*playersN)]);
        p.col=color(0,255,0);
      }
      p.spawn();
    }
    
    maxScore=max(players[0].score,maxScore); //новый лучший счёт, если сть
    maxScoreInGen=players[0].score;
    averageInGen=c/playersN;
    average=0.7*average+0.3*averageInGen;
  }
  
  
  fill(200);
  text(generation+" "+int(maxScore)+" "+int(maxScoreInGen)+" "+
       averageInGen+" "+average+" "+frameRate,100,50);
  dnn.display();
}
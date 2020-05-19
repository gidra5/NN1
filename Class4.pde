class DisplayNeuralNetwork
{
  NeuralNetwork nn;
  float x,y,s=50,r=30;
  
  DisplayNeuralNetwork(NeuralNetwork nn, float x, float y)
  {
    this.nn=nn;
    this.x=x;
    this.y=y;
  }
  
  void display()
  {
    for(int i=0;i<nn.layersN;++i)
      for(int j=0;j<nn.layers[i].neuronsN;++j)
      { 
        for(int k=0;k<nn.layers[i].neurons[j].weightsN;++k)
        {
          float temp=255*(2/(1+exp(-nn.layers[i].neurons[j].weights[k]/5))-1);
          stroke(max(0,temp),abs(temp),-min(0,temp));
          line(x+2*s*(1+i),y+s*j,x+2*s*i,y+s*k);
          stroke(0);
        }
        fill(max(0,255*nn.layers[i].neurons[j].value),0,-min(0,255*nn.layers[i].neurons[j].value));
        ellipse(x+2*s*(1+i),y+s*j,r,r);
        fill(255);
        text(nn.layers[i].neurons[j].value,x+2*s*(1+i),y+s*j);    
      }
    for(int a=0;a<nn.input.length;++a)
    {
      fill(max(0,255*nn.input[a]),0,-min(0,255*nn.input[a]));
      ellipse(x,y+s*a,r,r);
      fill(255);
      text(nn.input[a],x,y+s*a);
    }
  }
}
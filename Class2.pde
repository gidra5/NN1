 class NeuralNetwork
 {
   int layersN;
   NeuronLayer[] layers;
   int inputN;
   float[] input;
   
   NeuralNetwork(int[] neuronsPerLayer)
   {
     layersN=neuronsPerLayer.length-1;
     layers=new NeuronLayer[layersN];
     for(int i=0;i<layersN;++i)
       layers[i]=new NeuronLayer(neuronsPerLayer[i+1],neuronsPerLayer[i]);
     
     this.inputN=neuronsPerLayer[0]; //первый слой - входные данные
     input=new float[inputN];
   }
   
   void initInput()
   {
     for(int i=0;i<inputN;++i)
       input[i]=0;
   }
   
   void randomInit()
   {
     for(int i=0;i<layersN;++i)
       for(int j=0;j<layers[i].neuronsN;++j)
       {
         for(int k=0;k<layers[i].neurons[j].weightsN;++k)
           layers[i].neurons[j].weights[k]=random(-1,1)*10;
         layers[i].neurons[j].bias=random(-1,1)*10;
       }
   }
   
   float[] umph()
   {
     float[] output=input;
     
     for(int i=0; i<layersN;++i)
       output=layers[i].calcLayer(output);
     
     backprop(input);
     
     return output;
   }
   
   void backprop(float[] input)
   {
     float[] desiredO=new float[layers[layersN-1].neuronsN];
     
     desiredO[0]=input[2]-input[0]-input[4];
     desiredO[1]=input[1]-input[3]-input[5];
     float temp=sqrt(sq(desiredO[0])+sq(desiredO[1]));
     desiredO[0]/=temp;
     desiredO[1]/=temp;
     
     for(int i=layersN-1; i>0;--i)
     {
       float[] data=new float[layers[i-1].neuronsN];
         
       for(int j=0;j<layers[i].neuronsN;++j) 
       {
         for(int k=0; k<layers[i].neurons[j].weightsN; ++k)
         {
           if(j==0)
             data[k]=layers[i-1].neurons[k].value;
           layers[i].neurons[j].weights[k]+=0.001*(desiredO[j]-layers[i].neurons[j].value)
                                      *layers[i].neurons[j].df
                                      *layers[i-1].neurons[k].value;
           data[k]+=0.001*(desiredO[j]-layers[i].neurons[j].value)
                   *layers[i].neurons[j].df
                   *layers[i].neurons[j].weights[k];
         }
         layers[i].neurons[j].bias+=0.001*(desiredO[j]-layers[i].neurons[j].value)
                                   *layers[i].neurons[j].df;
       }
       desiredO=data;
     }
   }
 }
 class NeuronLayer
 {
   int neuronsN;
   Neuron[] neurons;
   
   NeuronLayer(int neuronsN,int prevLayerNeuronsN)
   {
     this.neuronsN=neuronsN;      //сколько нейронов в слое
     neurons=new Neuron[neuronsN];
     for(int i=0;i<neuronsN;++i)
       neurons[i]=new Neuron(prevLayerNeuronsN); 
     //каждый нейрон имеет весы 
     //на каждый нейрон из прошлого слоя
   }
   
   float[] calcLayer(float[] input)
   {
     float[] data=new float[neuronsN];
     for(int i=0;i<neuronsN;++i) 
       data[i]=neurons[i].calcValue(input);
     return data;
   }
 }
 
 class Neuron
 {
   int weightsN;
   float[] weights,dw;
   float bias=0;
   float value=0;
   float df=0,db=0;
   
   Neuron(int weightsN)
   {
     this.weightsN=weightsN;
     weights=new float[weightsN];
     dw=new float[weightsN];
     for(int i=0;i<weightsN;++i)
       dw[i]=0;
   }
   
   float calcValue(float[] input) //input - значения нейронов в прошлом слое
   {
     float sum=0;
     for(int i=0;i<weightsN;++i)
     {
       sum+=input[i]*weights[i];
     }
     value=func(sum-bias);
     df=0.5*(value+1)*(value+1)*exp(bias-sum);
     
     return value;
   }
   
   float func(float v)
   {
     return 2/(1+exp(-v))-1;
     //return atan(v)/PI+0.5;
   }
 }
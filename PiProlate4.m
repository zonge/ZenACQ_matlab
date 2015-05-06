function [DataVector]=PiProlate4(DataVector)


c4Pi=[ 2.6197747176990866d-11 2.9812025862125737d-10 3.0793023552299688d-9 ...
       2.8727486379692354d-8  2.4073904863499725d-7  1.8011359410323110d-6 ...
       1.1948784162527709d-5  6.9746276641509466d-5  3.5507361197109845d-4 ...
       1.5607376779150113d-3  5.8542015072142441d-3  1.8482388295519675d-2 ...
       4.8315671140720506d-2  1.0252816895203814d-1  1.7233583271499150d-1 ...
       2.2242525852102708d-1  2.1163435697968192d-1  1.4041394473085307d-1 ...
       5.9923940532892353d-2  1.4476509897632850d-2  1.5672417352380246d-3 ...
       4.2904633140034110d-5];

% Weight0=sqrt(2/0.50812554814747497);
   Weight0=sqrt(4/0.50812554814747497);
   
NumPoints=length(DataVector);

 NTerms=22;       
              
for K=1:NumPoints
  factor1=(2*K-1)/NumPoints-1;
  factor1=(1-factor1)*(1+factor1);
                  
  Weight= c4Pi(1)*factor1;
  for L=2:NTerms-1;
    Weight=(Weight+c4Pi(L))*factor1;
  end 

  Weight=Weight+c4Pi(NTerms);

  %xx(K,1)= Weight0+Weight;
  %yy(K,1)=Weight;
  DataVector(K)=DataVector(K)*Weight*Weight0;

end 
               
              
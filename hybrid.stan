data{
int<lower=0>numobs; //number of observations (single number)
int obs[numobs]; // a real vector of observed data with length (numobs)
int<lower=0> forecastnum; //number of forecasts 
int<lower=0> lag; //number of previous days we are using for kernel
int lagvec[lag]; //lag vector 
int<lower=0> pop; //population size
real<lower=0> foieps; //non-zero hack eps for foi 
real<lower=0> kappa; //constant parameter for inc
real<lower=0> effRepHa; // beta parameter for effRep
real<lower=0> effRepHb; //beta parameter for effRep 
real<lower=0> preExp; // exponiental parameter for preInc
real<lower=0> hetShape; //gamma shape for alpha
real<lower=0> hetMean; // gamma parameter for alpha
real<lower=0> shapeH; //gamma shape and rate paramter for incshape and repshape
real<lower=0> Rshape;//gamma shape parameter for R0
real<lower=0> Rmean; //gamma paramter for R0
real<lower=0> gpShape; //beta parameter for genPos
real<lower=0> gpMean; //beta parameter for genPos
real<lower=0> gsShape; //gamma shape parameter for genShape 
real<lower=0> gsMean; //gamma parameter for genShape
}
parameters{
real<lower=0> genPos;
real<lower=0> forecastobs[forecastnum];
real<lower=0> genShape;
real<lower=0> effRep;
real<lower=0> preInc[forecastnum+lag+numobs];
real<lower=0> alpha;
real<lower=0> repShape;
real<lower=0> incShape;
real<lower=0,upper=1> RRprop;
real<lower=0> R0;
real<lower=0> obsMean[numobs+forecastnum];
}
model{
real gen;
real effProp;
real repMean;
vector[lag+numobs+forecastnum] S;
vector[lag+numobs+forecastnum] inc;
vector[lag] preker;
vector[lag] ker;
vector[numobs+forecastnum] foi;
vector[numobs+forecastnum] preIncShape;
//vector[forecastnum] forecastobs;
  # Dispersion
repShape ~ gamma(shapeH, shapeH);
incShape ~ gamma(shapeH, shapeH);

# Effective population size and response
alpha ~ gamma(hetShape, hetShape/hetMean);
effRep ~ beta(effRepHa, effRepHb);
RRprop ~ uniform(0, 1);
effProp <- pow(effRep,1-RRprop);
repMean <- pow(effRep,RRprop);

S[1] <- effProp*pop;

# Kernel and pre-observation period
R0 ~ gamma(Rshape, Rshape/Rmean);

genPos ~ beta(gpShape/(1-gpMean), gpShape/gpMean);
genShape ~ gamma(gsShape, gsShape/gsMean);

for (j in 1:lag){
  preker[j] <- pow(j, genShape/(1-genPos))*pow(lag-j+1,genShape/genPos);
  preInc[j] ~ exponential(preExp);
}
for (j in 1:lag){
	ker[j] <- R0*preker[j]/sum(preker);
	print("preker=",preker,", ker=", ker, ", preInc=",preInc);
}
# Updates that are consistent over both periods
for(j in 1:(lag+numobs)){
  inc[j] <- foieps + S[j]*repMean*(1 - pow(1+preInc[j]/(S[j]*repMean*kappa), -kappa));
  S[j+1] <- foieps + S[j] - inc[j]/repMean;
}

# Observation period
for (j in 1:numobs){
	foi[j] <- (ker[1]*inc[j+4] + ker[2]*inc[j+3] + ker[3]*inc[j+2] + ker[4]*inc[j+1] + ker[5]*inc[j+0])*pow(S[lag+j]/S[1], 1+alpha)+foieps;

  preIncShape[j] <- (incShape*foi[j]/repMean)/(incShape+foi[j]/repMean);
//  print("incShape=",incShape,", foi=",foi,", repMean=",repMean);
	preInc[lag+j] ~ gamma(preIncShape[j], preIncShape[j]/foi[j]);

# Observation process
obsMean[j] ~ gamma(repShape, repShape/inc[lag+j]);
obs[j] ~ poisson(obsMean[j]);
}


for(j in 1:forecastnum){
  S[lag+numobs+j+1] <- foieps + S[numobs+lag+j] - inc[j+lag+numobs]/repMean;
  inc[lag+numobs+j] <- foieps + S[lag+numobs+j]*repMean*(1 - pow(1+preInc[lag+numobs+j]/(S[lag+numobs+j]*repMean*kappa), -kappa));
  
  foi[numobs+j] <- (ker[1]*inc[numobs+j+4] + ker[2]*inc[numobs+j+3] + ker[3]*inc[numobs+j+2] + ker[4]*inc[numobs+j+1] + ker[5]*inc[numobs+j+0])*pow(S[numobs+lag+j]/S[1], 1+alpha)+foieps;

  preIncShape[numobs+j] <- (incShape*foi[numobs+j]/repMean)/(incShape+foi[numobs+j]/repMean);
	preInc[numobs+lag+j] ~ gamma(preIncShape[numobs+j], preIncShape[numobs+j]/foi[numobs+j]);
  
  
  obsMean[numobs+j] ~ gamma(repShape, repShape/inc[numobs+lag+j]);
  forecastobs[j] ~ gamma(obsMean[numobs+j],1);
}

# Summary parameters
gen <- (lagvec[1]*ker[1]+lagvec[2]*ker[2]+lagvec[3]*ker[3]+
        lagvec[4]*ker[4]+lagvec[5]*ker[5])/R0;
}


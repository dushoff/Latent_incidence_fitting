max=30
seed = 903
trans = c(0, 0, 0, 1, 2)
p_obs = 0.5

set.seed(seed)

cases = numeric()
cases[1]=1

for(day in 2:max){
	cases[day] = 0
	for(prev in 1:(day-1)){
		if(length(trans)>=(day-prev)){
			cases[day] = cases[day] + rpois(n=1, cases[prev]*trans[day-prev])
		}
	}
}

obs = rbinom(length(cases), cases, p_obs)
sim <- data.frame(cases=cases, obs=obs)

plot(1:max, cases, type = "both")
lines(1:max, obs, type = "both")

#rdsave(sim)

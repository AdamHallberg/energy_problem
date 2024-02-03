using JuMP, HiGHS

model 	= Model(with_optimizer(GLPK.Optimizer))

time_range 	= collect(1:48) # time range 1:48
reactor_range 	= collect(1:4) # reactor range 1:4
p_max 		= [280, 120, 90, 100]
p_min 		= [100, 35, 30, 40]
beta 		= [490, 500, 600, 300]
dtime 		= [8 , 6 , 6, 6]
startup_cost 	= [15000, 5500, 5400, 3000]
# Decision variables
@variable(model, lambda[t] >= 0, Int)		# Expected electricity price
@variable(model, startup[reactor, t] >= 0, Int) # Startup a reactor
@variable(model, p[reactor, t] >= 0, Int) 	# Produced at reactor
@variable(model, u[reactor], Bin)		# Reactor status on/off

@objective(model, Max, sum(sum( u[reactor] * p[reactor, t] * (lambda[t] - beta[reactor]) - startup[reactor, t] * startup_cost[reactor, time]) for t in time_range) for reactor in reactor_range)

@constraint(model, i in 

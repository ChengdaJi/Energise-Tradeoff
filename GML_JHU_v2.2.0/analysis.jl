using CSV
using DataFrames

T = 288;

Cost = zeros(1,288)
Pg = zeros(12,288)
for time=1:T
    name=string("results/ten_min_anc/p_rate/p_rate_75/solar/solar_25/ten_min_anc_p_rate_75_solar_25_time", time, ".csv");
    data_trace = CSV.File(name) |> DataFrame
    Cost_temp= collect(data_trace[:,Symbol("Cost")])
    Cost[1,time] = Cost_temp[1]
    Pg_temp= collect(data_trace[:,Symbol("Pg")])
    Pg[:,time] = Pg_temp
    # Time_temp= collect(data_trace[:,Symbol("Time")])
    # Cost[1,time] = Time_temp[1]
end
println(sum(Pg))
println(sum(Cost))

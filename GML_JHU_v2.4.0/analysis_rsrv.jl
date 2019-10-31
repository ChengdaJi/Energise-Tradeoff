using CSV
using DataFrames
using Plots

T = 288;

# penetation levels
p_rate = [0.75];

# chance constraint [50, 99] #[95, 90, 85]
cc = [90 95 99];

# prediction length
Pred_length = [30 60 120];

# max solar error
solar_error_max = [0.025, 0.1, 0.2];

B_cap = [3 15 30];

P_rsrv= zeros(3,288)
B_rsrv = zeros(3,288)
i=1;
for sem in solar_error_max
    for p in p_rate

        folder = "./results_1011/"; filename = "";
        folder = string(folder, "ten_min_anc/");
        filename = string(filename, "ten_min_anc_");
        folder = string(folder, "p_rate/p_rate_", Integer(p*100), "/");
        filename = string(filename, "p_rate_", Integer(p*100), "_");
        folder = string(folder, "solar/solar_", Integer(sem*1000), "/")
        filename = string(filename, "solar_", Integer(sem*1000), "_")
        for time=1:T
            name=string(filename, "time", time, ".csv");
            data_trace = CSV.File(string(folder, name)) |> DataFrame
            P_temp= collect(data_trace[:,Symbol("P_rsrv")])
            P_rsrv[i,time] = P_temp[1]
            B_temp= collect(data_trace[:,Symbol("B_rsrv")])
            B_rsrv[i,time] = B_temp[1]
        end
    end
    global i=i+1
end
# println(size(reshape(P_rsrv[1,:],288,1)))
plot(1:288, reshape(P_rsrv[1,:],288,1))
plot!(1:288, reshape(P_rsrv[2,:],288,1))
plot!(1:288, reshape(P_rsrv[3,:],288,1))
# plot(1:288, P_rsrv(1,:))


# for b_cap in B_cap
#     cost_sum_ra = [];
#     pg_sum_ra = [];
#     for p in p_rate
#
#         folder = "./results_1014/"; filename = "";
#         folder = string(folder, "ten_min_anc/");
#         filename = string(filename, "ten_min_anc_");
#         folder = string(folder, "p_rate/p_rate_", Integer(p*100), "/");
#         filename = string(filename, "p_rate_", Integer(p*100), "_");
#         folder = string(folder, "b_cap/b_cap_", b_cap, "/")
#         filename = string(filename, "b_cap_", b_cap, "_")
#
#
#         for time=1:T
#             name=string(filename, "time", time, ".csv");
#             data_trace = CSV.File(string(folder, name)) |> DataFrame
#             P_temp= collect(data_trace[:,Symbol("P_rsrv")])
#             P_rsrv[i,1,time] = Cost_temp[1]
#             B_temp= collect(data_trace[:,Symbol("B_rsrv")])
#             B_rsrv[i,1,time] = B_temp[1]
#             # Time_temp= collect(data_trace[:,Symbol("Time")])
#             # Cost[1,time] = Time_temp[1]
#         end
#     end
#     i=i+1
# end
# CSV.write("./results_1011/analysis/bat_table_cost.csv", df_cost)
# CSV.write("./results_1011/analysis/bat_table_power.csv", df_power)
# return "finish"

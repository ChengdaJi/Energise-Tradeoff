using CSV
using DataFrames
using Plots

T = 288;

# Ancillar Markets Considered: "without", "10min", "30min"
a_types="10min"

# penetation levels
p_rate = [0.25 0.5 0.75 1.0]

# chance constraint [50, 99] #[95, 90, 85]
cc = [90 95];

# prediction length
Pred_length = [30 60 120];

# max solar error
solar_error_max = [0.025, 0.05, 0.1, 0.5];
Solve_time = zeros(288,4)
pp=0
    for p in p_rate
            global pp = pp+1
            c = 95;
            folder = string("./results_0912/");
            folder = string(folder, "ten_min_anc/");
            filename = "ten_min_anc_";
            folder = string(folder, "p_rate/p_rate_", Integer(p*100), "/");
            filename = string(filename, "p_rate_", Integer(p*100), "_");

            folder = string(folder, "cc/cc_", c, "/")
            filename = string(filename, "cc_", c, "_")


            for time=1:T
                name=string(filename, "time", time, ".csv");
                data_trace = CSV.File(string(folder, name)) |> DataFrame
                Time_temp= collect(data_trace[:,Symbol("time")])
                Solve_time[time,pp] = Time_temp[1]
            end

    end

filename_out = "solvetime.csv"
CSV.write(filename_out, DataFrame(Solve_time, [:SP25, :SP50, :SP100, :SP75]));

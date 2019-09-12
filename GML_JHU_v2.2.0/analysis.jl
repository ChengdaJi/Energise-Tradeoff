using CSV
using DataFrames

T = 288;

# Ancillar Markets Considered: "without", "10min", "30min"
a_types=["without", "10min"]

# penetation levels
p_rate = [0.25, 0.5, 0.75, 1];

# chance constraint [50, 99] #[95, 90, 85]
cc = [50 85 90 95 99];

# prediction length
Pred_length = [30 60 120];

# max solar error
solar_error_max = [0.025, 0.05, 0.1, 0.5];

for a_type in a_types
    for p in p_rate

        # for c in cc
        #
        #     folder = "results/"; filename = "";
        #     if a_type == "without"
        #         folder = string(folder, "no_anc/");
        #         filename = string(filename, "no_anc_");
        #     elseif a_type == "10min"
        #         folder = string(folder, "ten_min_anc/");
        #         filename = string(filename, "ten_min_anc_");
        #     end
        #     folder = string(folder, "p_rate/p_rate_", Integer(p*100), "/");
        #     filename = string(filename, "p_rate_", Integer(p*100), "_");
        #
        #     folder = string(folder, "cc/cc_", c, "/")
        #     filename = string(filename, "cc_", c, "_")
        #
        #     Cost = zeros(1,288)
        #     Pg = zeros(12,288)
        #     for time=1:T
        #         name=string(filename, "time", time, ".csv");
        #         data_trace = CSV.File(string(folder, name)) |> DataFrame
        #         Cost_temp= collect(data_trace[:,Symbol("Cost")])
        #         Cost[1,time] = Cost_temp[1]
        #         Pg_temp= collect(data_trace[:,Symbol("Pg")])
        #         Pg[:,time] = Pg_temp
        #     end
        #
        #     println(filename)
        #     println(sum(Pg))
        #     println(sum(Cost))
        #     println()
        # end

        for pred_length in Pred_length
            folder = "results/"; filename = "";
            if a_type == "without"
                folder = string(folder, "no_anc/");
                filename = string(filename, "no_anc_");
            elseif a_type == "10min"
                folder = string(folder, "ten_min_anc/");
                filename = string(filename, "ten_min_anc_");
            end
            folder = string(folder, "p_rate/p_rate_", Integer(p*100), "/");
            filename = string(filename, "p_rate_", Integer(p*100), "_");

            folder = string(folder, "pred/pred_", pred_length, "/")
            filename = string(filename, "pred_", pred_length, "_")

            Cost = zeros(1,288)
            Pg = zeros(12,288)
            for time=1:T
                name=string(filename, "time", time, ".csv");
                data_trace = CSV.File(string(folder, name)) |> DataFrame
                Cost_temp= collect(data_trace[:,Symbol("Cost")])
                Cost[1,time] = Cost_temp[1]
                Pg_temp= collect(data_trace[:,Symbol("Pg")])
                Pg[:,time] = Pg_temp
            end

            println(filename)
            println(sum(Pg))
            println(sum(Cost))
            println()
        end

        # for sem in solar_error_max
        #
        #     folder = "results/"; filename = "";
        #     if a_type == "without"
        #         folder = string(folder, "no_anc/");
        #         filename = string(filename, "no_anc_");
        #     elseif a_type == "10min"
        #         folder = string(folder, "ten_min_anc/");
        #         filename = string(filename, "ten_min_anc_");
        #     end
        #     folder = string(folder, "p_rate/p_rate_", Integer(p*100), "/");
        #     filename = string(filename, "p_rate_", Integer(p*100), "_");
        #
        #     folder = string(folder, "solar/solar_", Integer(sem*1000), "/")
        #     filename = string(filename, "solar_", Integer(sem*1000), "_")
        #
        #     Cost = zeros(1,288)
        #     Pg = zeros(12,288)
        #     for time=1:T
        #         name=string(filename, "time", time, ".csv");
        #         data_trace = CSV.File(string(folder, name)) |> DataFrame
        #         Cost_temp= collect(data_trace[:,Symbol("Cost")])
        #         Cost[1,time] = Cost_temp[1]
        #         Pg_temp= collect(data_trace[:,Symbol("Pg")])
        #         Pg[:,time] = Pg_temp
        #         # Time_temp= collect(data_trace[:,Symbol("Time")])
        #         # Cost[1,time] = Time_temp[1]
        #     end
        #     println(filename)
        #     println(sum(Pg))
        #     println(sum(Cost))
        #     println()
        #
        # end

    end
end

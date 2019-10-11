using CSV
using DataFrames
using Plots
using MAT


include("traj_gen_det.jl")

price_raw = read_price_data()
delta_rt_raw=matread("../data/price_prediction.mat");

## read read_demand_data
pd_raw = read_demand_data()
pd_noise = matread("../data/demand_noise.mat")["demand_noise"];
pg_raw = read_solar_data()

T = 288;

# Ancillar Markets Considered: "without", "10min", "30min"
a_types="10min"

# penetation levels
p_rate = 1

# chance constraint [50, 99] #[95, 90, 85]
cc = 90;

# prediction length
Pred_length = [20];

# max solar error
solar_error_max = [0.025, 0.05, 0.1, 0.5];

pd = pd_traj_det(1, pd_raw, T)
Pd_b1 = reshape(sum(pd.traj[1:4,:], dims=1),288,1);
Pd_b2 = reshape(sum(pd.traj[5:8,:], dims=1),288,1);
Pd_b3 = reshape(sum(pd.traj[9:12,:], dims=1),288,1);
pg = pg_traj_det(1, pg_raw, p_rate, T);
Pg_b1_aval = reshape(sum(pg.mu[1:4,:], dims=1),288,1);
Pg_b2_aval = reshape(sum(pg.mu[5:8,:], dims=1),288,1);
Pg_b3_aval = reshape(sum(pg.mu[9:12,:], dims=1),288,1);
# Pg_headnode_det2 = reshape(sum(pg.mu[5:8,:], dims=1),288,1);

for p in p_rate
        folder = string("../GML_JHU_v2.2.0/results_0912/");
        folder = string(folder, "ten_min_anc/");
        filename = "ten_min_anc_";
        folder = string(folder, "p_rate/p_rate_", Integer(p*100), "/");
        filename = string(filename, "p_rate_", Integer(p*100), "_");
        folder = string(folder, "cc/cc_", cc, "/")
        filename = string(filename, "cc_", cc, "_")

        Cost = zeros(1,288)
        Pg = zeros(12,288)
        R = zeros(12,288)
        Qf = zeros(12,288)
        for time=1:T
            name=string(filename, "time", time, ".csv");
            data_trace = CSV.File(string(folder, name)) |> DataFrame
            Cost_temp= collect(data_trace[:,Symbol("Cost")])
            Cost[1,time] = Cost_temp[1]
            Pg_temp= collect(data_trace[:,Symbol("Pg")])
            Pg[:,time] = Pg_temp
            Qf_temp= collect(data_trace[:,Symbol("QF")])
            Qf[:,time] = Qf_temp
            R_temp= collect(data_trace[:,Symbol("R")])
            R[:,time] = R_temp
        end
        global Pg_b1 = reshape(sum(Pg[1:4,:], dims=1),288,1)
        global Pg_b2 = reshape(sum(Pg[5:8,:], dims=1),288,1)
        global Pg_b3 = reshape(sum(Pg[9:12,:], dims=1),288,1)
        global R_b1 = reshape(sum(R[1:4,:], dims=1),288,1)
        global R_b2 = reshape(sum(R[5:8,:], dims=1),288,1)
        global R_b3 = reshape(sum(R[9:12,:], dims=1),288,1)
        global Qf_b1 = reshape(sum(Qf[1:4,:], dims=1),288,1)
        global Qf_b2 = reshape(sum(Qf[5:8,:], dims=1),288,1)
        global Qf_b3 = reshape(sum(Qf[9:12,:], dims=1),288,1)
end

# curtailment rate
curt=zeros(288,1)
curt100=ones(288,1)
bank = 1;
for timeslot = 1:288
    if bank == 1
        if Pg_b1_aval[timeslot] > 0
            curt[timeslot] = Pg_b1_aval[timeslot] - Pg_b1[timeslot];
            curt100[timeslot] = curt[timeslot]/Pg_b1_aval[timeslot];
        end
    elseif bank == 2
        if Pg_b2_aval[timeslot] > 0
            curt[timeslot] = Pg_b2_aval[timeslot] - Pg_b2[timeslot];
            curt100[timeslot] = curt[timeslot]/Pg_b2_aval[timeslot];
        end
    elseif bank == 3
        if Pg_b3_aval[timeslot] > 0
            curt[timeslot] = Pg_b3_aval[timeslot] - Pg_b3[timeslot];
            curt100[timeslot] = curt[timeslot]/Pg_b3_aval[timeslot];
        end
    end
end
plot(1:288, curt100, lw=2, label="curtailment rate")
# plot!(1:288, Pg_b3_aval, lw=2, label="availability")
# plot!(1:288, Pg_b3, lw=2, label="solar use")
title!("(Pg_aval-Pg)/Pa_aval")
xlabel!("Time")
ylabel!("[MW]")


# plot(1:288, Pg_b1_aval, label="Solar availability Pg", lw=2)
# plot!(1:288, Pg_b1, label="Solar used Pg", lw=2)
# plot!(1:288, Pd_b1, label="Demand Pd", lw=2)
# plot!(1:288, R_b1, label="Battery discharge R", lw=2)
# plot!(1:288, Qf_b1, label="Reactive power Q", lw=2)
# plot!(1:288, Pd_b1-Pg_b1-R_b1, label="P on bank", lw=2)
# xlabel!("Time")
# ylabel!("Solar [MW]")

# plot(1:288, Pg_b2_aval, label="Solar availability Pg", lw=2)
# plot!(1:288, Pg_b2, label="Solar used Pg", lw=2)
# plot!(1:288, Pd_b2, label="Demand Pd", lw=2)
# plot!(1:288, R_b2, label="Battery discharge R", lw=2)
# plot!(1:288, Qf_b2, label="Reactive power Q", lw=2)
# plot!(1:288, Pd_b2-Pg_b2-R_b2, label="P on bank", lw=2)
# xlabel!("Time")
# ylabel!("Solar [MW]")
#
# plot(1:288, Pg_b3_aval, label="Solar availability Pg", lw=2)
# plot!(1:288, Pg_b3, label="Solar used Pg", lw=2)
# plot!(1:288, Pd_b3, label="Demand Pd", lw=2)
# plot!(1:288, R_b3, label="Battery discharge R", lw=2)
# plot!(1:288, Qf_b3, label="Reactive power Q", lw=2)
# plot!(1:288, Pd_b3-Pg_b3-R_b3, label="P on bank", lw=2)
# xlabel!("Time")
# ylabel!("Solar [MW]")

        # for pred_length in Pred_length
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
        #     folder = string(folder, "pred/pred_", pred_length, "/")
        #     filename = string(filename, "pred_", pred_length, "_")
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

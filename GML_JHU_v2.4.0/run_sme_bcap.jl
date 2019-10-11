# This runs all of the jobs necessary for our trade-off analysis

include("main.jl")

# # of timeslots
T=288;
# # of banks
# BN=252;
BN=3;
# # of feeders
F=BN*4;
# # of secnarios
SN=6;

################################################################################

# Ancillar Markets Considered: "without", "10min", "30min"
ancillary_type = "10min"
# penetation levels
# p_rate = [0.25 0.5 0.75, 1]; #[0.25, 0.5, 0.75, 1];
p_rate = [0.25, 0.5, 0.75, 1];

# chance constraint [90,95,99]
icdf = [-1.2816, -1.6449, -2.3263]
# prediction length [2hr, 1hr, .5hr]
Pred_length = [24, 12, 6];

# max solar error
solar_error_max = [0.025, 0.1, 0.2];

# max solar error
B_cap = [3, 15, 30];
################################################################################

# load price data
price_raw = read_price_data()
delta_rt_raw=matread("../data/price_prediction.mat");

# read demand data
pd_raw = read_demand_data()
pd_noise = matread("../data/demand_noise.mat")["demand_noise"];

# read pg noise
pg_noise = matread("../data/solar_noise_0025.mat")["solar_noise"];

# read pg_raw
pg_raw = read_solar_data()

# baseline is 95% chance constraint, 2 hour prediction length,
# and maximum solar error variance 0.025
default_i = -1.6449; default_pred_length = 12; default_sem = 0.1; default_B_cap = 3;

for p in p_rate


    for sem in solar_error_max

        folder = string("./results_1011/");
        folder = string(folder, "ten_min_anc/");
        filename = "ten_min_anc_";
        folder = string(folder, "p_rate/p_rate_", Integer(p*100), "/");
        filename = string(filename, "p_rate_", Integer(p*100), "_");

        folder = string(folder, "solar/solar_", Integer(sem*1000), "/")
        filename = string(filename, "solar_", Integer(sem*1000));

        main(ancillary_type, T, BN, F, SN, p, default_i, default_pred_length, sem,
             price_raw, delta_rt_raw, pd_raw, pd_noise, pg_noise, pg_raw,
             folder, filename, default_B_cap);
    end

    for bc in B_cap

        folder = string("./results_1011/");
        folder = string(folder, "ten_min_anc/");
        filename = "ten_min_anc_";
        folder = string(folder, "p_rate/p_rate_", Integer(p*100), "/");
        filename = string(filename, "p_rate_", Integer(p*100), "_");
        folder = string(folder, "b_cap/b_cap_", Integer(bc), "/")
        filename = string(filename, "b_cap_", Integer(bc));

        main(ancillary_type, T, BN, F, SN, p, default_i, default_pred_length, default_sem,
             price_raw, delta_rt_raw, pd_raw, pd_noise, pg_noise, pg_raw,
             folder, filename, bc);
    end
end

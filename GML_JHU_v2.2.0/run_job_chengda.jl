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
ancillary_type=["without", "10min"]


# penetation levels
p_rate = [0.25, 0.5, 0.75, 1];

# chance constraint [95, 90, 85]
icdf = [-1.6449,-1.2816, -1.0364];

# prediction length [2hr, 1hr, .5hr]
# Pred_length = [24, 12, 6];

# max solar error
# solar_error_max = [0.025, 0.05, 0.1];
################################################################################

# load price data
price_raw = read_price_data()
delta_rt_raw=matread("../data/price_prediction.mat");

# read demand data
pd_raw = read_demand_data()
pd_noise = matread("../data/demand_noise.mat")["demand_noise"];

# read pg noise
pg_noise_25 = matread("../data/solar_noise_0025.mat")["solar_noise"];
pg_noise_05 = matread("../data/solar_noise_005.mat")["solar_noise"];
pg_noise_01 = matread("../data/solar_noise_01.mat")["solar_noise"];

# read pg_raw
pg_raw = read_solar_data()

# baseline is 95% chance constraint, 2 hour prediction length,
# and maximum solar error variance 0.025
default_i = -1.6449; default_pred_length = 24; default_sem = 0.1;

ancillary_type = "without"
    for p =0.7:0.7:0.7
        for i =1:1
            folder = string("./results/");
            filename = "";
            if ancillary_type == "without"
                folder = string(folder, "no_anc/");
                filename = "no_anc_";
            end
            folder = string(folder, "p_rate/p_rate_", Integer(p*100), "/");
            filename = string(filename, "p_rate_", Integer(p*100), "_");
            if i == 1
                icdf = 0
                folder = string(folder, "cc/cc_10/");
                filename = string(filename, "cc_10");
            elseif i == 2
                icdf = -1.2816
                folder = string(folder, "cc/cc_90/");
                filename = string(filename,"cc_90");
            elseif i==3
                icdf = -1.0364
                folder = string(folder, "cc/cc_85/");
                filename = string(filename,"cc_85");
            end

            main(ancillary_type, T, BN, F, SN, p, icdf, default_pred_length, default_sem,
                 price_raw, delta_rt_raw, pd_raw, pd_noise, pg_noise_25, pg_raw,
                 folder, filename);

        end

    end

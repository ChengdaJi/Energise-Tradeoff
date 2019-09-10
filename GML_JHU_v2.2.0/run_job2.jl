# This runs all of the jobs necessary for our trade-off analysis
using Distributed

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
Pred_length = [24, 12, 6];

# max solar error
solar_error_max = [0.025, 0.05, 0.1];
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
default_i = -1.6449; default_pred_length = 24; default_sem = 0.025;

for a_type in ancillary_type
    for p in p_rate

        # for i in icdf
        #
        #     folder = string("./results/");
        #     filename = "";
        #     if a_type == "without"
        #         folder = string(folder, "no_anc/");
        #         filename = "no_anc_";
        #     elseif a_type == "10min"
        #         folder = string(folder, "ten_min_anc/");
        #         filename = "ten_min_anc_";
        #     end
        #     folder = string(folder, "p_rate/p_rate_", Integer(p*100), "/");
        #     filename = string(filename, "p_rate_", Integer(p*100), "_");
        #     if i == -1.6449
        #         folder = string(folder, "cc/cc_95/");
        #         filename = string(filename, "cc_95");
        #     elseif i == -1.2816
        #         folder = string(folder, "cc/cc_90/");
        #         filename = string(filename,"cc_90");
        #     elseif i == -1.0364
        #         folder = string(folder, "cc/cc_85/");
        #         filename = string(filename,"cc_85");
        #     end
        #
        #     main(a_type, T, BN, F, SN, p, i, default_pred_length, default_sem,
        #          price_raw, delta_rt_raw, pd_raw, pd_noise, pg_noise_25, pg_raw,
        #          folder, filename);
        #
        # end

        for pred_length in Pred_length

            folder = string("./results/");
            filename = "";
            if a_type == "without"
                folder = string(folder, "no_anc/");
                filename = "no_anc_";
            elseif a_type == "10min"
                folder = string(folder, "ten_min_anc/");
                filename = "ten_min_anc_";
            end
            folder = string(folder, "p_rate/p_rate_", Integer(p*100), "/");
            filename = string(filename, "p_rate_", Integer(p*100), "_");

            folder = string(folder, "pred/pred_", Integer(pred_length*5), "/");
            filename = string(filename, "pred_", Integer(pred_length*5));

            main(a_type, T, BN, F, SN, p, default_i, pred_length, default_sem,
                 price_raw, delta_rt_raw, pd_raw, pd_noise, pg_noise_25, pg_raw,
                 folder, filename);

        end

        # for sem in solar_error_max
        #
        #     folder = string("./results/");
        #     filename = "";
        #     if a_type == "without"
        #         folder = string(folder, "no_anc/");
        #         filename = "no_anc_";
        #     elseif a_type == "10min"
        #         folder = string(folder, "ten_min_anc/");
        #         filename = "ten_min_anc_";
        #     end
        #     folder = string(folder, "p_rate/p_rate_", Integer(p*100), "/");
        #     filename = string(filename, "p_rate_", Integer(p*100), "_");
        #
        #     folder = string(folder, "solar/solar_", Integer(sem*1000), "/")
        #     filename = string(filename, "solar_", Integer(sem*1000));
        #
        #     if sem == 0.025
        #         pg_noise = pg_noise_25;
        #     elseif sem == 0.05
        #         pg_noise = pg_noise_05;
        #     elseif sem == 0.1
        #         pg_noise = pg_noise_01;
        #     end
        #
        #     main(a_type, T, BN, F, SN, p, default_i, default_pred_length, sem,
        #          price_raw, delta_rt_raw, pd_raw, pd_noise, pg_noise, pg_raw,
        #          folder, filename);
        #
        # end
    end
end
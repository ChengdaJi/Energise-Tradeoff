# This runs all of the jobs necessary for our trade-off analysis

include("main.jl")

ancillary_type="10min"
# ancillary_type="30min"
# ancillary_type="Without"

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

# baseline is 50% solar, 95% chance constraint, 2 hour prediction length,
# and maximum solar error variance 0.025
default_p = 0.25; default_i = -1.6449; default_pred_length = 24; default_sem = 0.025;

for p in p_rate
    folder = string("./results/p_rate/p_rate_", Integer(p*100), "/");
    filename = string("p_rate_", Integer(p*100));

    main(T, BN, F, SN, p, default_i, default_pred_length, default_sem,
         price_raw, delta_rt_raw, pd_raw, pd_noise, pg_noise_25, pg_raw,
        folder, filename);
end

for i in icdf
    folder = "";
    filename = "";
    if i == -1.6449
        folder = "./results/cc/cc_95/"
        filename = "cc_95";
    elseif i == -1.2816
        folder = "./results/cc/cc_90/"
        filename = "cc_90";
    elseif i == -1.0364
        folder = "./results/cc/cc_85/"
        filename = "cc_85";
    end

    main(T, BN, F, SN, default_p, i, default_pred_length, default_sem,
         price_raw, delta_rt_raw, pd_raw, pd_noise, pg_noise_25, pg_raw,
         folder, filename);

end

for pred_length in Pred_length
    folder = string("./results/pred/pred_", Integer(pred_length*5), "/");
    filename = string("pred_", Integer(pred_length*5));

    main(T, BN, F, SN, default_p, default_i, pred_length, default_sem,
         price_raw, delta_rt_raw, pd_raw, pd_noise, pg_noise_25, pg_raw,
         folder, filename);

end

for sem in solar_error_max
    folder = string("./results/solar/solar_", Integer(sem*1000), "/")
    filename = string("solar_", Integer(sem*1000));

    if sem == 0.025
        pg_noise = pg_noise_25;
    elseif sem == 0.05
        pg_noise = pg_noise_05;
    elseif sem == 0.1
        pg_noise = pg_noise_01;
    end

    main(T, BN, F, SN, default_p, default_i, default_pred_length, sem,
         price_raw, delta_rt_raw, pd_raw, pd_noise, pg_noise, pg_raw,
         folder, filename);

end

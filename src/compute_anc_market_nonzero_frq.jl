using CSV
using Dates
using Plots
using DataFrames

function compute_anc_market_nonzero_frq(filename, dates)
    # This function computes the frequency of nonzero ancillary prices in the
    # 10 and 30 minute non-synchronous ancillary markets. Note this isn't
    # efficient, but shouldn't have to run this often.
    # You can save the result using:
    #   writetable("../data/nonzero_filename.csv",anc_market_price_frq)

    anc_market_data = CSV.File(filename; dateformat="yyyy/mm/dd HH:MM:SS") |> DataFrame;
    anc_market_price_frq = DataFrame(Date=Date[], TenMinFrq=Int64[], ThirtyMinFrq=Int64[]);

    for date in dates
        ten_min_frq = 0;
        thirty_min_frq = 0;
        for i in 1:size(anc_market_data, 1)
            if (date == Dates.Date(anc_market_data[i,Symbol("RTD End Time Stamp")])
                && "HUD VL" == anc_market_data[i,Symbol("Zone Name")])

                if 0 != anc_market_data[i,Symbol("RTD 10 Min Non Sync")]
                    ten_min_frq += 1
                end
                if 0 != anc_market_data[i,Symbol("RTD 30 Min Non Sync")]
                    thirty_min_frq += 1
                end
            end
        end

        anc_market_price_frq = vcat(anc_market_price_frq,
            DataFrame(Date=date,TenMinFrq=ten_min_frq, ThirtyMinFrq=thirty_min_frq))

    end

    return anc_market_price_frq
end

# run above function and save for most of 2019
filename = "../data/OASIS_Real_Time_Dispatch_Ancillary_Services.csv";
dates = Dates.Date(2019, 1, 1):Dates.Day(1):Dates.Date(2019, 8, 14);

anc_market_frq = compute_anc_market_nonzero_frq(filename, dates)

CSV.write("../data/Nonzero_OASIS_Real_Time_Dispatch_Ancillary_Services.csv",
    anc_market_frq);

# Days with non zero ten min TenMinFrq
#nonzero_tenmin_days = anc_market_price_frq[anc_market_price_frq[:,:TenMinFrq] .!= 0, :Date]
#nonzero_thirtymin_days = anc_market_price_frq[anc_market_price_frq[:,:ThirtyMinFrq] .!= 0, :Date]

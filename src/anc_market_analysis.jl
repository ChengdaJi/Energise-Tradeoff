using StatsPlots
using DataFrames
using CSV
using Plots.PlotMeasures
using Statistics
using Dates
using Formatting

# load the data
filename = "../data/Nonzero_OASIS_Real_Time_Dispatch_Ancillary_Services.csv";
anc_market_data = CSV.File(filename; dateformat="yyyy-mm-dd") |> DataFrame

# create plot for all 2019
@df anc_market_data bar(:Date, :TenMinFrq + :ThirtyMinFrq,
    title="Nonzero Ancillary Market Prices in 2019",
    xlabel="Date",
    ylabel="Frequency",
    label=[""],
    dpi=200,
    size=(800,600))
savefig("../figures/bar_2019_nonzero_ancillary_pricing")

# number of days with nonzero TenMin prices
num_total = size(anc_market_data,1);
num_ten = count(x -> (x != 0), anc_market_data[:,:TenMinFrq])
num_thirty = count(x -> (x != 0), anc_market_data[:,:ThirtyMinFrq])
num_none = count(x -> (x == 0),
    anc_market_data[:,:ThirtyMinFrq] + anc_market_data[:,:TenMinFrq])
num_ten_and_thirty = num_ten + num_thirty + num_none - num_total
num_ten_only = num_ten - num_ten_and_thirty
num_thirty_only = num_thirty - num_ten_and_thirty
percent_none = num_none/num_total * 100
percent_ten_only = num_ten_only/num_total * 100
percent_thirty_only = num_thirty_only/num_total * 100
percent_ten_and_thirty = num_ten_and_thirty/num_total * 100
fspec = FormatSpec(".1f")
labels = ["None ($(fmt(fspec,percent_none))%)",
    "10 Min ($(fmt(fspec,percent_ten_only))%)",
    "10 and 30 Min ($(fmt(fspec,percent_ten_and_thirty))%)",
    "30 Min ($(fmt(fspec,percent_thirty_only))%)"]
plt = pie(labels,
    [num_none, num_ten_only, num_ten_and_thirty, num_thirty_only],
    title="Breakdown of Days with Nonzero Ancillary Prices in 2019",
    margin=8mm,
    dpi=200);
savefig(plt, "../figures/pie_ancillary_prices")

# Now we wish to consider typical behavior only on days with nonzero ancillary prices
nonzero_anc_market_data = anc_market_data[anc_market_data[:,:TenMinFrq] .!= 0,:]
plt = boxplot(repeat([1],size(nonzero_anc_market_data,1)),
    nonzero_anc_market_data[:, :TenMinFrq],
    title="Nonzero Ten Minute Prices for Days with Any Nonzero Ancillary Prices",
    ylabel="Frequency",
    bar_width = .2,
    label=[""],
    xlims=(0,2),
    dpi=200,
    titlefontsize=10,
    minorgrid=true);
savefig(plt, "../figures/boxplot_ten_min")
println(quantile(nonzero_anc_market_data[:, :TenMinFrq], Base.range(0,stop=1,length=5)))

plt = boxplot(repeat([1],size(nonzero_anc_market_data,1)),
    nonzero_anc_market_data[:, :ThirtyMinFrq],
    title="Nonzero Thirty Minute Prices for Days with Any Nonzero Ancillary Prices",
    ylabel="Frequency",
    bar_width = .2,
    label=[""],
    xlims=(0,2),
    dpi=200,
    titlefontsize=10,
    minorgrid=true);
savefig(plt, "../figures/boxplot_thirty_min")

# If we wish to consider typical behavior only on day with nonzero 30 min
# ancillary prices
nonzero_anc_market_price_30 = nonzero_anc_market_data[
    nonzero_anc_market_data[:,:ThirtyMinFrq] .!= 0,:]
plt = boxplot(repeat([1],size(nonzero_anc_market_price_30,1)),
    nonzero_anc_market_price_30[:, :ThirtyMinFrq],
    title="Nonzero Thirty Minute Prices for Days with Any Nonzero 30 Minute Ancillary Prices",
    ylabel="Frequency",
    bar_width = .2,
    label=[""],
    xlims=(0,2),
    dpi=200,
    titlefontsize=8,
    minorgrid=true);
savefig(plt, "../figures/boxplot_thirty_min_limited_scope")

# Now we can understand what different numbers of nonzero prices in Feb and Aug
# mean
anc_market_data_feb = anc_market_data[
    map(x -> Dates.Month(x) == Dates.Month(2), anc_market_data[:,:Date]), :]

@df anc_market_data_feb bar([:Date; :Date], [:TenMinFrq; :ThirtyMinFrq],
    title="Nonzero Ancillary Market Prices in February",
    xlabel="Date",
    ylabel="Frequency",
    label=[""],
    dpi=200,
    size=(800,600),
    minorgrid=true)
savefig("../figures/bar_feb_nonzero_ancillary_pricing")

anc_market_data_aug = anc_market_data[
    map(x -> Dates.Month(x) == Dates.Month(8), anc_market_data[:,:Date]), :]
@df anc_market_data_aug bar(:Date, :TenMinFrq,
    title="Nonzero Ancillary Market Prices in August",
    xlabel="Date",
    ylabel="Frequency",
    label=[""],
    dpi=200,
    size=(800,600),
    minorgrid=true)
    savefig("../figures/bar_aug_nonzero_ancillary_pricing")

# We selected Feb 28th, 2019 so creating a csv holding on relevant data for that
# day...
filename = "../data/OASIS_Real_Time_Dispatch_Ancillary_Services_Feb28.csv";
price_trace = CSV.File(filename; dateformat="yyyy/mm/dd HH:MM:SS") |> DataFrame;
# pull out relevant info
selected_price_trace = price_trace[
    (map(x -> Dates.Date(x) == Dates.Date(2019,2,28),
        price_trace[:,Symbol("RTD End Time Stamp")])) .& (price_trace[:,Symbol("Zone Name")] .== "HUD VL"),
    [Symbol("RTD End Time Stamp"),
    Symbol("RTD 10 Min Non Sync"),
    Symbol("RTD 30 Min Non Sync")]]

CSV.write("../data/anc_price_trace_feb28_2019.csv",
    selected_price_trace);

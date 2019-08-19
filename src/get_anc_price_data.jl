function get_anc_price_data()
    filename = "../data/anc_price_trace_feb28_2019.csv"
    price_trace = CSV.File(filename; dateformat="yyyy-mm-dd") |> DataFrame

    timestamp = collect(price_trace[:,Symbol("RTD End Time Stamp")])
    ten_min_price = collect(price_trace[:,Symbol("RTD 10 Min Non Sync")])
    thirty_min_price = collect(price_trace[:,Symbol("RTD 30 Min Non Sync")])

    return (timestamp, ten_min_price, thirty_min_price)

end

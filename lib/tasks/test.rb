require "csv"

csvPath = "sample_hardware_data.csv"
header = true
CSV.foreach(csvPath) do |row|
    if header == true
        header = false
    else
        puts(row) 
    end
end
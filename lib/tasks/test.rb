require "csv"

# csvPath = "sample_hardware_data.csv"
header = true

hardware_items = []

CSV.foreach("sample_hardware_data.csv") do |row|
    if header == true
        header = false
    else
        item = HardwareItem.new(
            {
            upc: row[0],
            name: row[1],
            count: row[2],
            category: row[3],
            location: row[4]
            })
        hardware_items.push(item)
        
    end
end

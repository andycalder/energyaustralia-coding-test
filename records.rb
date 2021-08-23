require 'open-uri'
require 'json'

url = 'https://eacp.energyaustralia.com.au/codingtest/api/v1/festivals'
response = URI.open(url).read
data = JSON.parse(response)

# Transform data into an easier to use shape
# labels = {
#   'Record Label 1' => {
#     'Band 1' => ['Festival 1', 'Festival 2'],
#     'Band 2' => ['Festival 1', 'Festival 2']
#   }
# }
labels = {}
data.each do |festival|
  festival_name = festival['name']
  next unless festival_name

	festival['bands'].each do |band|
    band_name = band['name']
    label_name = band['recordLabel']
    next unless band_name && label_name && label_name.length > 0
    
    labels[label_name] ||= {}
    labels[label_name][band_name] ||= []
    labels[label_name][band_name].push(festival_name)
	end
end

# Print output
labels.sort.to_h.each do |label_name, bands|
  puts label_name

  bands.sort.to_h.each do |band_name, festivals|
    puts '  ' + band_name

    festivals.sort.each do |festival_name|
      puts '    ' + festival_name
    end
  end
end

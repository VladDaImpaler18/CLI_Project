# (c) 2020 Vladimir Jimenez, all rights reserved
# For Online Software Engineering PT - CLI Project

class Api

    #Dir.pwd                is CLI_Project/
    #File.dirname(__FILE__) is CLI_Project/lib/object
    #Dir.chdir(File.join(File.dirname(__FILE__), 'lib/data/.cache/'))
    @@cache_directory = File.join(Dir.pwd, 'lib/data/.cache/')

    def self.get_parks(state_code)
        Dir.mkdir(File.join(Dir.pwd, 'lib/data/.cache/')) unless File.exists?(File.join(Dir.pwd, 'lib/data/.cache/'))
        #Dir.chdir(File.join(Dir.pwd, 'lib/data/.cache/'))
        @state_code = state_code
        check_cache_or_get_data
    end

    def self.check_cache_or_get_data
        check_cache || download_data_with_state_code
    end

    def self.download_data_with_state_code
        puts "Downloading parks data, this operation may time some time..."
        api_key = ENV["MY_NPS_KEY"]
        url = "https://developer.nps.gov/api/v1/parks?stateCode=#{@state_code}&api_key=#{api_key}"
        response = Net::HTTP.get(URI(url))
        File.write("#{@@cache_directory}#{@state_code}.json", response, mode: "w")
        puts "Park data downloaded and saved."
        parks = JSON.parse(response)["data"]
        parks.each do |park_info|
            Park.new(name: park_info["name"], url: park_info["url"], operatingHours: park_info["operatingHours"], description: park_info["description"], addresses: park_info["addresses"], entranceFees: park_info["entranceFees"], parkCode: park_info["parkCode"], contacts: park_info["contacts"])
        end
    end

    def self.check_cache #Check if file exists, then make sure it's not ERROR
        if File.file?("#{@@cache_directory}#{@state_code}.json")
             file = File.open("#{@@cache_directory}#{@state_code}.json", "r")
             loaded_json = JSON.load(file) 
             if !loaded_json.keys.include?("error")
                parks = loaded_json["data"]
                parks.each do |park_info|
                    Park.new(name: park_info["name"], url: park_info["url"], operatingHours: park_info["operatingHours"], description: park_info["description"], addresses: park_info["addresses"], entranceFees: park_info["entranceFees"], parkCode: park_info["parkCode"], contacts: park_info["contacts"])
                end
                puts "Park data loaded from cache."
                true #File existed AND it does not contain a key "error" and Park.all has been populated
            else
                puts "Cache data bad, redownloading..."
                false #File existed but has key "error" so invalid
            end
        else
            false #File doesn't exist
        end
     end
     
end

#total_parks = JSON.parse(response)["total"] #NY=37, starts at 0
#park[x] = JSON.parse(response)["data"][x]
#Things of interest
# name:
# url:
# directionsURL:
# operatingHours: => [ {"exceptions"=> {"exceptionHours" => {"Wednesday" => "Closed", "Sunday" => "Closed", etc}, "name" => "Thanksgiving Day", "startDate"=>, "endDate" => "YYYY-MM-DD"},multiple exceptions...}, description:, standardHours: => {wednesday:, :monday,...}, name:  ]     
# parkCode: 
# description: 
# designation: "National Historical Park"
# addresses: [{mailing}{"postalCode"=>, "city" =>", stateCode:, line1:(street address), type: => "physical", line2:, line3: }] #physical and mailing, 
# entranceFees
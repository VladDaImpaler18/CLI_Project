# (c) 2020 Vladimir Jimenez, all rights reserved
# For Online Software Engineering PT - CLI Project
class Park

    attr_accessor :name, :url, :operatingHours, :parkCode, :description, :addresses, :entranceFees, :contacts
    @@all=[]

    def initialize(name:, operatingHours:, parkCode:, description:, url:, addresses:, entranceFees:, contacts:)
        @name = name
        @operatingHours = operatingHours
        @parkCode = parkCode
        @description = description
        @url = url
        @addresses = addresses
        @entranceFees = entranceFees
        @contacts = contacts

        @@all << self
    end

    def self.find_by_name(name)
        self.all.select{|park_obj| park_obj.name==name}
    end

    def self.all
        @@all
    end

    def self.clear_all
        @@all.clear
    end

end

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
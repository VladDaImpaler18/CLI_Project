# (c) 2020 Vladimir Jimenez, all rights reserved
# For Online Software Engineering PT - CLI Project
class Cli

    @state_code=nil
    

    def initialize
        load_state_list
    end

    def run
        puts " "
        puts "Hello, welcome to my NPS app!"
        puts " "
        while @state_code==nil
            puts "\nEnter a State Code to see National Park Sites in that state."
            puts "If you don't know the state code, enter \"List\" for a list of states and their code."
            puts " "
            input = gets.strip.upcase
            if (@state_list.keys.include?(input))
                @state_code = input
                puts "You inputted #{@state_code} - #{@state_list[@state_code]}."
            elsif input == "List".upcase
                print_states
            elsif (input == "Exit".upcase || input == "Quit".upcase)
                exit 
            else
                puts "\nIncorrect state code, please try again."
            end
        end
        
        Api.get_parks(@state_code)
        print_list_of_parks(Park.all)
        user_picks_park
    end #run

    def print_states
        puts " "
        count=1
        @state_list.each do |code,name|
            print "#{code} - #{name}".ljust(25) if count%2==1
            puts "#{code} - #{name}" if count%2==0 
            count+=1
        end
    end #print_states
   
    def load_state_list
        @state_list = Hash.new
        filepath = File.join(Dir.pwd, 'lib/data/statecodes')
        file = File.open(filepath,"r").each do |line|
                state_name=line.split(",")[0].strip
                state_code=line.split(",")[1].strip
                @state_list[state_code]=state_name
            end
    end #load_state_list

    def print_list_of_parks(parks)
        puts " "
        puts "There are #{parks.size} parks sites located in #{@state_code} - #{@state_list[@state_code]}."
        puts "Below is the list of parks "
        parks.each.with_index(1) do |park, index| 
            puts "#{index}. #{park.name}"
        end
        puts " "
    end #print_list_of_parks(1)

    def user_picks_park
        while 42
            puts "\nEnter the park number for more details. Valid options: (1-#{Park.all.size})\nMore options: X) exit  -  L) list parks"
            puts " "
            
            input = gets.strip.downcase
            if (input == "l" || input == "list" || input == "list parks")
                print_list_of_parks(Park.all)
            elsif (input == "exit" || input == "x")
                exit
            else
                display_park_info(input)
            end
        end
    end #user_picks_park

    def display_park_info(park_choice)
        
        if park_choice.match?(/\b\d+\b/) #checks to see if input is even a number
            index = park_choice.to_i - 1
            
            if index >= 0 && Park.all[index].nil? == false
                #checks to see if number input is a valid array index AND positive
                park = Park.all[index]
                #gets address (physical only for location)
                street_address = ""
                city = ""
                zip = ""
                state = ""
                park.addresses.each do |address|
                    if address["type"] == "Physical"
                        street_address += address["line1"]
                        street_address += ", #{address["line2"]}" if !address["line2"].empty? 
                        street_address += ", #{address["line3"]}" if !address["line3"].empty?
                        city = address["city"]
                        zip = address["postalCode"]
                        state = address["stateCode"] 
                    end
                end #FINISH-gets address
                line_width = 130
                border = "".ljust(line_width,'=')
                breaker = "".ljust(line_width/3) + "".center(line_width/3,"-")
                puts border
                puts "#{park.name} (#{park.parkCode})".center(130)
                puts breaker
                puts ""
                pretty_output(long_sentance: park.description, line_width: line_width)
                puts ""
                puts "Address:"
                puts "\t#{street_address}, #{city}, #{state}, #{zip}".ljust(130)
                puts ""
                #contact info
                puts "Contact Info:"
                park.contacts.each do |platform|
                    platform.last.each do |medium|
                        if platform.first["phoneNumbers"] 
                            print "\t#{medium["type"]}:" unless medium["type"].empty?
                            print " #{medium["phoneNumber"].gsub(/^(\d{3})(\d+)(\d{4})$/, '\1-\2-\3')} "
                            print "ext: #{medium["extension"]}" unless medium["extension"].empty?
                            puts ""
                        elsif platform.first["emailAddresses"]
                            puts "Email Addresses:"
                            puts "\t#{medium["emailAddress"]}"
                        end                        
                    end
                end #FINISH-contact info
                puts ""
                park.operatingHours.each do |facility|
                    puts breaker
                    puts "#{facility["name"]}"
                    pretty_output(long_sentance: facility["description"], line_width: line_width)
                    puts "\nHours of operation:"
                    count = 1
                        facility["standardHours"].each do |day,hours|
                            print "#{day.capitalize}: #{hours}".ljust(50) if count%2 == 1
                            puts "#{day.capitalize}: #{hours}" if count%2 == 0
                            count += 1
                        end
                    puts ""
                    puts ""             
                end
                puts "\nVisit the website for more information: #{park.url}"
                puts border + "\n"
            else
                #BAD: not valid index code
                puts "#{park_choice} is an invalid number. Valid numbers: [1-#{Park.all.size}]\nTry again...\n"
            end
        else 
            #BAD: input has non-digits code
            puts "#{park_choice} is an invalid entry. Please pick the number corresponding to the park you want more info on.\n"
        end

    end #display_park_info

    def pretty_output(long_sentance:, line_width:)
        letterCount=0
        lineOutput=""
        words = long_sentance.split(" ")
        words.each do |word|
            letterCount += word.size + 1 #to account for space
            if letterCount < line_width
                lineOutput += " #{word}" unless lineOutput.empty?
                lineOutput = "#{word}" if lineOutput.empty?
                end
                if letterCount >= line_width
                    puts lineOutput
                    letterCount = word.size + 1
                    lineOutput = "#{word}"
                end
            end
        puts lineOutput
    end #pretty_output(2)
    

end

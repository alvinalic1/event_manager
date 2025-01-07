require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'
require 'time'
puts 'Event Manager Initialized!'

#Display the entire contents of the file
# exists = File.exist?('event_attendees.csv')
# puts exists
# contents = File.read('event_attendees.csv')
# puts contents

# Display each name from the line, skipping the header row
# lines = File.readlines('event_attendees.csv')
# lines.each_with_index do |line, index|
#   next if index == 0
#   columns = line.split(",")
#   name = columns[2]
#   puts name
# end


#Now I will switch from using this CSV parser I created to using Rubys CSV
#This allows you to include the fact that their are headers so it skips over it naturally
#It also gives you the ability to convert heads to more uniformed names

# contents = CSV.open(
#   'event_attendees.csv', 
#   headers: true,
#   header_converters: :symbol
#   )
# contents.each do |row|
#   name = row[:first_name]
#   zipcode = row[:zipcode]
#   puts "#{name} #{zipcode}"
# end


#Most zipcodes are 5 digits, some are more, some are less and some are empty
#I will do nothing if zipcode is 5 digits
#I will add zeros to the front if it is less than 5
#And remove dgits from the end if greater than 5

#Long winded method
# def clean_zipcode(zipcode)
#   if zipcode.nil?
#     '00000'
#   elsif zipcode.length < 5
#     zipcode.rjust(5, '0')
#   elsif zipcode.length > 5
#     zipcode[0..4]
#   else
#     zipcode
#   end
# end

# #Shorter method
# def clean_zipcodes_nicer(zipcode)
#   zipcode.to_s.rjust(5, '0')[0..4]
# end

# contents = CSV.open(
#   'event_attendees.csv', 
#   headers: true,
#   header_converters: :symbol
#   )
# contents.each do |row|
#   name = row[:first_name]
#   zipcode = clean_zipcode(row[:zipcode])
  
#   puts "#{name} #{zipcode}"
# end



#Using google civic API
#
# def clean_zipcode(zipcode)
#   zipcode.to_s.rjust(5,"0")[0..4]
# end

# def legislators_by_zipcode(zip)
#   civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
#   civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

#   begin
#     civic_info.representative_info_by_address(
#       address: zip,
#       levels: 'country',
#       roles: ['legislatorUpperBody', 'legislatorLowerBody']
#     ).officials
#   rescue
#     'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
#   end
# end

# def save_thank_you_letter(id,form_letter)
#   Dir.mkdir('output') unless Dir.exist?('output')

#   filename = "output/thanks_#{id}.html"

#   File.open(filename, 'w') do |file|
#     file.puts form_letter
#   end
# end


# contents = CSV.open(
#   'event_attendees.csv',
#   headers: true,
#   header_converters: :symbol
# )

# template_letter = File.read('form_letter.erb')
# erb_template = ERB.new template_letter

# contents.each do |row|
#   id = row[0]
#   name = row[:first_name]
#   zipcode = clean_zipcode(row[:zipcode])
#   legislators = legislators_by_zipcode(zipcode)

#   form_letter = erb_template.result(binding)

#   save_thank_you_letter(id,form_letter)
# end




##Assignment 

##part 1
#
contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)
#Method to clean up numnbers so that the string contains numbers only
def remove_special_characters(number)
  #Delete all special character from the number
  new_number = number.delete('^a-zA-Z0-9 ')
  #Delete all whitespaces in the number
  new_number = new_number.delete(" \t\r\n")
  #return new cleaned up number
  new_number
end

#Method to check the length of the number and make necessery adjustment
def clean_number(number)
  num_length = number.length

  if(num_length == 10)
    number
  elsif(num_length == 11 && number[0]=="1")
    #prints all numbers starting from index 1
    number[1..-1]
  elsif(num_length > 11 || num_length < 10 || (num_length == 11 && number[0]!="1"))
    "Valid Number not listed"
  end

end

#Method to add parenthesis and dash to make it look like a real phone number
def format_number(number)
  if(number.length == 10)
    formatted = number.insert(0, '(')
    formatted = formatted.insert(4, ')')
    formatted = formatted.insert(8, '-')
    formatted
  else
    number
  end
end

contents.each do |row|
  phone_number = row[:homephone]
  clean_num = remove_special_characters(phone_number)
  formated_num = clean_number(clean_num)
  formated_num = format_number(formated_num)
  #puts formated_num
  
end


#Part 2
#
contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
  )

  date_and_time = Array.new

  contents.each do |row|
    datetime = row[:regdate]
    dt = Time.strptime(datetime, '%m/%d/%y %H:%M')
    dt = dt.strftime("%k:%M")
    date_and_time.push(dt)
    # dt = Time.parse(datetime)
    # puts dt
    # date = Date.strptime(datetime, "%d/%m/%Y")
    # puts date
    # puts datetime
    

    # dates.push(date_and_time[0])
    # times.push(date_and_time[1])
  end
  puts date_and_time
  

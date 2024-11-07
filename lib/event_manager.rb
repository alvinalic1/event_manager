puts 'Event Manager Initialized!'

#Display the entire contents of the file
# content = File.read('event_attendees.csv')
# puts content

# Display each name from the line, skipping the header row
lines = File.readlines('event_attendees.csv')
lines.each_with_index do |line, index|
  next if index == 0
  line_array = line.split(',')
  name = line_array[2]
  puts name
end


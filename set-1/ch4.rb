#!/usr/bin/env ruby

require './xor'

candidates = []
File.open('ch4.txt', 'r') do |f|
  while line = f.gets
    candidates += test_is_message(line.chomp)
  end
end

msg = best_candidate(candidates)

check = msg == "Now that the party is jumping\n"

puts "#{msg}#{check ? 'OK' : 'BAD'}"

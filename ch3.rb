#!/usr/bin/env ruby

require './xor'

msg = best_candidate(test_is_message('1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736'))

check = msg == "Cooking MC's like a pound of bacon"

puts "#{msg} #{check ? 'OK' : 'BAD'}"

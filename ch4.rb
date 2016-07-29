#!/usr/bin/env ruby

require './xor'

candidates = []
while line = gets
  candidates += test_is_message(line.chomp)
end

puts best_candidate(candidates)

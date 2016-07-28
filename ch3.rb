#!/usr/bin/env ruby

def frequency(candidate, input)
  input.scan(candidate).length
end

def frequency_pct(candidate, input)
   Float(frequency(candidate, input)) / input.length
end

def test_is_english(input)
  score = 100

  score -= 10 unless frequency(' ', input) >= 2

  # see: https://en.wikipedia.org/wiki/Letter_frequency#Relative_frequencies_of_letters_in_the_English_language

  score -= 8 unless frequency_pct(/e/i, input) >= 7 # avg is 12.702%

  score -= 8 unless frequency_pct(/t/i, input) >= 4 # avg is 9.056%

  score -= 5 unless frequency_pct(/a/i, input) >= 4 # avg is 8.167%

  score -= 5 unless frequency_pct(/o/i, input) >= 3 # avg is 7.507%

  score -= 5 unless frequency_pct(/i/i, input) >= 3 # avg is 6.966%

  score
end

input = '1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736'

input_unpacked = [input].pack('H*').unpack('C*')

('A'...'z').each do |char|
  candidate_bytes = input_unpacked.map { |inp_byte| char.ord ^ inp_byte }
  candidate = candidate_bytes.pack('C*')

  score = test_is_english(candidate)
  puts "#{char}/#{char.ord} - #{score} - #{candidate}" if score >= 60
end

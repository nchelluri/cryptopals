#!/usr/bin/env ruby

def hamming_distance(a, b)
  unless a.length == b.length
    puts "wrong length"
    return 0
  end

  a_bytes = a.unpack('C*')
  b_bytes = b.unpack('C*')
  a_bytes_xor_b_bytes = []

  (0...a_bytes.length).each do |i|
    a_bytes_xor_b_bytes << (a_bytes[i] ^ b_bytes[i])
  end

  num_ones = 0
  a_bytes_xor_b_bytes.each do |b|
    [1,2,4,8,16,32,64,128].each do |val|
      if val & b > 0
        num_ones += 1
      end
    end
  end

  num_ones
end

distance = hamming_distance("this is a test", "wokka wokka!!!")

check = distance == 37

puts "#{distance} #{check ? 'OK' : 'BAD'}"

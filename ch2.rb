#!/usr/bin/env ruby

a = "1c0111001f010100061a024b53535009181c"
a_bytes = [a].pack('H*').unpack('C*')

b = "686974207468652062756c6c277320657965"
b_bytes = [b].pack('H*').unpack('C*')

output_bytes = []
for i in 0...a_bytes.length
  output_bytes << (a_bytes[i] ^ b_bytes[i])
end

output = output_bytes.pack('C*').unpack('H*').first

expected = '746865206b696420646f6e277420706c6179'

puts "#{output} #{output == expected ? 'OK' : 'BAD'}"

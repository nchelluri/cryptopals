#!/usr/bin/env ruby

hex = '49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d'
expected = 'SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t'

# decode a hex encoded string
# puts [hex].pack('H*')

actual = [[hex].pack('H*')].pack('m0*')

puts "#{actual} #{expected == actual ? 'OK' : 'BAD'}"

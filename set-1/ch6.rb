#!/usr/bin/env ruby

require './xor'

# distance = hamming_distance("this is a test".unpack('C*'), "wokka wokka!!!".unpack('C*'))
#
# check = distance == 37
#
# puts "#{distance} #{check ? 'OK' : 'BAD'}"

input_b64 = File.read('ch6.txt')
input_bytes = input_b64.unpack("m*").first.unpack('C*')

keysize_fits = []
(2..40).each do |keysize|
  hds = []
  0.upto(25 - 1) do |i|
    chunk_1 = input_bytes[keysize * i...keysize * (i+1)]
    chunk_2 = input_bytes[keysize * (i+1)...keysize * (i+2)]
    hd = hamming_distance(chunk_1, chunk_2)/Float(keysize)
    hds << hd
  end

  hd = hds.inject(:+) / 25

  keysize_fits << [keysize, hd]
end

expected_keysize = keysize_fits.sort_by { |ks| ks[1] }.first.first

blocks = []
0.step(input_bytes.length - 1, expected_keysize) do |i|
  blocks << input_bytes[i...i + expected_keysize]
end

new_blocks = []
0.upto(expected_keysize - 1) do |i|
  new_block = []
  blocks.each do |block|
    new_block << block[i]
  end

  new_blocks << new_block
end

new_block_strs = []
new_blocks.each do |new_block|
  new_block_str = new_block.reject{ |v| v.nil? }.pack('C*').unpack('H*').first
  new_block_strs << new_block_str
end

keys = []
new_block_strs.each do |new_block_str|
  bc = best_candidate(test_is_message(new_block_str), true)
  keys << bc[2].chr
end

key = keys.join('')
new = input_b64.unpack('m*').first
puts [xor_encrypt(key, new)].pack('H*')

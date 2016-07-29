#!/usr/bin/env ruby

require './xor'

def hamming_distance(a, b)
  unless a.length == b.length
    puts "wrong length"
    return 0
  end

  a_xor_b = []

  (0...a.length).each do |i|
    a_xor_b << (a[i] ^ b[i])
  end

  num_ones = 0
  a_xor_b.each do |b|
    [1,2,4,8,16,32,64,128].each do |val|
      if val & b > 0
        num_ones += 1
      end
    end
  end

  num_ones
end

# distance = hamming_distance("this is a test".unpack('C*'), "wokka wokka!!!".unpack('C*'))
#
# check = distance == 37
#
# puts "#{distance} #{check ? 'OK' : 'BAD'}"

input_b64 = File.read('ch6.txt')
input_bytes = input_b64.unpack("m*").first.unpack('C*')

keysize_fits = []
(2..40).each do |keysize|
  chunk_1 = input_bytes[0...keysize]
  chunk_2 = input_bytes[keysize...keysize * 2]
  hd_1 = hamming_distance(chunk_1, chunk_2)/Float(keysize)

  chunk_3 = input_bytes[keysize * 2...keysize * 3]
  chunk_4 = input_bytes[keysize * 3...keysize * 4]
  hd_2 = hamming_distance(chunk_3, chunk_4)/Float(keysize)

  keysize_fits << [keysize, hd_1 + hd_2/Float(2)]
end

expected_keysize = keysize_fits.sort_by { |ks| ks[2] }.first.first

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
  new_block_str = new_block.pack('C*').unpack('H*').first
  new_block_strs << new_block_str
end

keys = []
new_block_strs.each do |new_block_str|
  bc = best_candidate(test_is_message(new_block_str), true)
  puts bc.inspect
  keys << bc[2].chr
end

key = keys.join('')
puts key
new = input_b64.unpack('m*').first
puts [xor_encrypt(key, new)].pack('H*')

# keys = []
# new_block_strs.each do |new_block_str|
#   candidates = test_is_message(new_block_str)
#   keys << candidates.map { |c| c[2].chr }
# end
#
# valleys = []
# keys.first.each do |k1|
#   keys.last.each do |k2|
#     key = k1 + k2
#
#     input = input_b64.unpack('m*').first
#     valleys << [xor_encrypt(key, input)].pack('H*')
#   end
# end
#
# puts valleys.length
#
# valleys.each do |valley|
#   puts valley if score_likelihood_of_english(valley) >= 0
# end
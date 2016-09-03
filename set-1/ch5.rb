#!/usr/bin/env ruby

require './xor'

check = false
if ARGV.length != 2
  key = 'ICE'
  input = "Burning 'em, if you ain't quick and nimble\nI go crazy when I hear a cymbal"
  check = true
else
  key = ARGV[0]
  input = ARGV[1]
end

actual = xor_encrypt(key, input)
print actual

if check
  expected = "0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f"
  print actual == expected ? ' OK' : ' BAD'
end

print "\n"

# decryption
# new = [actual].pack('H*')
# puts [xor_encrypt(key, new)].pack('H*')

#!/usr/bin/env ruby

require 'openssl'

cipher = OpenSSL::Cipher.new('AES-128-ECB')
cipher.decrypt
cipher.key = 'YELLOW SUBMARINE'

text = IO.read('ch7.txt').unpack('m*').first

plain = cipher.update(text) + cipher.final

puts plain

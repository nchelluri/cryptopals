def frequency(candidate, input)
  input.scan(candidate).length
end

def frequency_pct(candidate, input)
  100 * Float(frequency(candidate, input)) / input.length
end

# BAD_VALUES = (0..8).map(&:ord).to_a + (11..31).map(&:ord).to_a + (126..255).map(&:ord).to_a

def score_likelihood_of_english(input)
  score = 100

  score -= 10 unless frequency(' ', input) >= 2

  # see: https://en.wikipedia.org/wiki/Letter_frequency#Relative_frequencies_of_letters_in_the_English_language

  score -= 8 unless frequency_pct(/e/i, input) >= 7 # avg is 12.702%
  score -= 8 unless frequency_pct(/t/i, input) >= 4 # avg is 9.056%
  score -= 5 unless frequency_pct(/a/i, input) >= 4 # avg is 8.167%
  score -= 5 unless frequency_pct(/o/i, input) >= 3 # avg is 7.507%
  score -= 5 unless frequency_pct(/i/i, input) >= 3 # avg is 6.966%
  score -= 5 unless frequency_pct(/n/i, input) >= 3 # avg is 6.749%

  [(0..8), (11..31), (126..255)].each do |range|
    range.each do |i|
      score -= 50 if input.include?(i.chr)
    end
  end

  score -= 50 if frequency_pct(/#{(33..47).map { |i| Regexp.escape(i.chr) }.join('|')}|#{(58..63).map { |i| Regexp.escape(i.chr) }.join('|')}|#{(123..125).map { |i| Regexp.escape(i.chr) }.join('|')}/, input) >= 10

  # score = 0
  #
  # input.each_char do |c|
  #   case c.downcase
  #     when 'e'
  #       score += 12.702
  #     when 't'
  #       score += 9.056
  #     when 'a'
  #       score += 8.167
  #     when 'o'
  #       score += 7.507
  #     when 'i'
  #       score += 6.966
  #     when 'n'
  #       score += 6.749
  #     when 's'
  #       score += 6.327
  #     when 'h'
  #       score += 6.094
  #     when 'r'
  #       score += 5.987
  #     when 'd'
  #       score += 4.253
  #     when 'l'
  #       score += 4.025
  #     when 'c'
  #       score += 2.782
  #     when 'u'
  #       score += 2.758
  #     when 'm'
  #       score += 2.406
  #     when 'w'
  #       score += 2.361
  #     when 'f'
  #       score += 2.228
  #     when 'g'
  #       score += 2.015
  #     when 'y'
  #       score += 1.974
  #     when 'p'
  #       score += 1.929
  #     when 'b'
  #       score += 1.492
  #     when 'v'
  #       score += 0.978
  #     when 'k'
  #       score += 0.772
  #     when 'j'
  #       score += 0.153
  #     when 'x'
  #       score += 0.150
  #     when 'q'
  #       score += 0.095
  #     when 'z'
  #       score += 0.074
  #     when *BAD_VALUES
  #       score -= 50
  #   end
  # end

  score
end

def test_is_message(input)
  input_unpacked = [input].pack('H*').unpack('C*')

  candidates = []

  (0..255).each do |ord|
    candidate_bytes = input_unpacked.map { |inp_byte| ord ^ inp_byte }
    candidate = candidate_bytes.pack('C*')

    score = score_likelihood_of_english(candidate)
    candidates << [candidate, score, ord]
  end

  candidates
end

def best_candidate(candidates, return_key = false)
  best_candidate = candidates.sort_by { |c| -c[1] }.first
  return_key ? best_candidate : best_candidate.first
end

def xor_encrypt(key, input)
  key_bytes = key.unpack('C*')

  input_bytes = input.unpack('C*')

  encrypted_bytes = []

  for i in 0...input_bytes.length
    encrypted_bytes << (input_bytes[i] ^ key_bytes[i % key_bytes.length])
  end

  encrypted_bytes.pack('C*').unpack('H*').first
end


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

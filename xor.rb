def frequency(candidate, input)
  input.scan(candidate).length
end

def frequency_pct(candidate, input)
  100 * Float(frequency(candidate, input)) / input.length
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
  score -= 5 unless frequency_pct(/n/i, input) >= 3 # avg is 6.749%

  score -= 50 if input =~ /#{(0..31).map { |i| i.chr }.join('|')}/
  score -= 50 if input =~ /#{(126..255).map { |i| i.chr }.join('|')}/
  score -= 50 if frequency_pct(/#{(33..47).map { |i| Regexp.escape(i.chr) }.join('|')}|#{(58..63).map { |i| Regexp.escape(i.chr) }.join('|')}|#{(123..125).map { |i| Regexp.escape(i.chr) }.join('|')}/, input) >= 10

  score
end

def test_is_message(input)
  input_unpacked = [input].pack('H*').unpack('C*')

  candidates = []

  (0..255).each do |ord|
    candidate_bytes = input_unpacked.map { |inp_byte| ord ^ inp_byte }
    candidate = candidate_bytes.pack('C*')

    score = test_is_english(candidate)
    candidates << [candidate, score]
  end

  candidates
end

def best_candidate(candidates)
  candidates.sort_by { |c| -c[1] }.first.first
end
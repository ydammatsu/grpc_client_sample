# frozen_string_literal: true

require_relative 'pb/sample_services_pb'

def main(input)
  stub = Example::Calc::Stub.new('localhost:50051', :this_channel_is_insecure)
  output = stub.solve(Example::Input.new(question: input))
  p "答えは #{output.answer}"
end

p '計算式を書いてください'
input = gets.chomp

main(input)
__END__

file_path = ARGV[0]

f = File.open(file_path)
file_name = File.basename(f.path)
file_blob = f.read

puts file_name, file_blob

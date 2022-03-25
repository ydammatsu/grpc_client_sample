file_path = ARGV[0]

f = File.open(file_path)
file_name = File.basename(f.path)
file_blob = f.read

puts file_name, file_blob

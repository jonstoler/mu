require "./vm.cr"

if ARGV.size != 1
  puts "Usage: #{PROGRAM_NAME} [file]"
  exit(1)
end

if File.exists?(ARGV[0])
  if File.readable?(ARGV[0])
    code = File.read(ARGV[0])
    vm = Mu::VM.new
    vm.bootstrap
    vm.exec(code)
  else
    puts "Could not read #{ARGV[0]}."
    exit(1)
  end
else
  puts "File #{ARGV[0]} does not exist."
  exit(1)
end

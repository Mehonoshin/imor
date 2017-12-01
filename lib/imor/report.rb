def calc_line(file_content, symbol_number)
  file_content[0..symbol_number].scan("\n").size + 1
end

lines = ARGV.map { |file_name| File.readlines(file_name) }.flatten

lines.each do |line|
  if line =~ /POSSIBLE_CHANGES/
    file_name, char_nums_str = line.split(' POSSIBLE_CHANGES: ')
    char_nums = eval(char_nums_str)
    file_content = File.read(file_name)
    char_nums.each do |char_num|
      puts "#{file_name}:#{calc_line(file_content, char_num)}"
    end
  end
end

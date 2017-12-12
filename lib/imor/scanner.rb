require 'imor/runner'

module Imor
  class Scanner
    def initialize(file_name, autofix_specs = true)
      @file_name = file_name
      @autofix_specs = autofix_specs
      @file_content = File.read(file_name)

      @offences = nil
    end

    def call
      return unless preliminary_run_successful?
      offences = detected_offences
      return if offences.empty?
      replace_possible_offences(offences)
      File.write(@file_name, @file_content)
    end

    private

    def preliminary_run_successful?
      puts 'preliminary check'
      successful_run?(@file_name)
    end

    def detected_offences
      @file_content.enum_for(:scan, /\screate([\(]|\s:)/).map { Regexp.last_match.begin(0) }
    end

    def replace_possible_offences(offences)
      succeed_substitutions_number = 0
      offences.each do |symbol_number|
        puts 'Substitute create'
        new_file_content = substitute_create(symbol_number, succeed_substitutions_number)
        line = calc_line(symbol_number)

        puts 'Run spec'
        if successful_run?(@file_name, line)
          succeed_substitutions_number += 1
          @file_content = new_file_content if @autofix_specs
        end
      end
    end

    def calc_line(symbol_number)
      @file_content[0..symbol_number].scan("\n").size + 1
    end

    def substitute_create(symbol_number, offset)
      new_file_content = @file_content[0..(symbol_number + (offset * 7))] + 'build_stubbed' + @file_content[(symbol_number + (offset + 1) * 7)..-1]
      File.write(@file_name, new_file_content)
      new_file_content
    end

    def successful_run?(spec_name, line = nil)
      Imor::Runner.new(spec_name, line).run
    end
  end
end

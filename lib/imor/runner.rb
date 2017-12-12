module Imor
  class Runner
    def initialize(spec_path, line = nil)
      @spec_path, @line = spec_path, line
      @result = nil
    end

    def run
      puts "RUN #{cmd}"
      @result = system(cmd)
    end

    private

    def cmd
      @cmd ||= "bundle exec bin/spring rspec #{@spec_path}#{':' + @line.to_s if @line}"
    end
  end
end

require 'date'

module TChart
  module DataReader
    def self.read(filename)
      File.open(filename) do |f| 
        settings, items, errors = DataParser.parse(filename, f) 
        print_errors_and_fail(errors) if not errors.empty?
        [ settings, items ]
      end
    end
    
    def self.print_errors_and_fail(errors)
      errors.each { |error| $stderr.puts(error) }
      raise TChartError, "Errors found; aborting."
    end
  end
end

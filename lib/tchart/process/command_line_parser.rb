module TChart
  class CommandLineParser
    
    def self.parse(argv) # => CommandLineArgs, errors
      CommandLineParser.new.parse(argv)
    end
    
    def parse(argv) # => CommandLineArgs, errors
      raise_usage if argv.length != 2
      data_filename, tex_filename = argv
      raise_data_filename_not_found(data_filename) if ! File.exists?(data_filename)
      raise_data_filename_not_a_file(data_filename) if ! File.file?(data_filename)
      raise_tex_filename_not_a_file(tex_filename) if File.exists?(tex_filename) && ! File.file?(tex_filename)
      raise_same_filename(data_filename, tex_filename) if same_file?(data_filename, tex_filename)
      [ CommandLineArgs.new(data_filename, tex_filename), [] ]
    rescue TChartError => e
      [ nil, [ e.message ] ]
    end
    
  private

    def same_file?(filename1, filename2)
      File.expand_path(filename1) == File.expand_path(filename2)
    end
  
    def raise_usage
      raise TChartError, "Usage: tchart input-data-filename output-tikz-filename"
    end
    
    def raise_data_filename_not_found(data_filename)
      raise TChartError, "Error: input data file \"#{data_filename}\" not found."
    end

    def raise_data_filename_not_a_file(data_filename)
      raise TChartError, "Error: input data file \"#{data_filename}\" is not a file."
    end
    
    def raise_tex_filename_not_a_file(tex_filename)
      raise TChartError, "Error: existing output data file \"#{tex_filename}\" is not a file."
    end
    
    def raise_same_filename(data_filename, tex_filename)
      raise TChartError, "Error: input \"#{data_filename}\" and output \"#{tex_filename}\" refer to the same file." 
    end

  end
end

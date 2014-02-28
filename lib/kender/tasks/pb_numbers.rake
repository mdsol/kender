namespace :pb do
  desc "finds duplicate PB numbers"
  task :duplicates do
    all = PBNumber.collect.inject( Hash.new(0) ) do | memo, pb_number |
      memo[pb_number.to_s] = [] if memo[pb_number.to_s] == 0
      memo[pb_number.to_s] << pb_number
      memo
    end

    duplicates = all.reject { |_, v | v.length == 1 }

    duplicates.each do |duplicate_pb_number, locations|
      puts "Found duplicate #{duplicate_pb_number}. Following is where it's used:"
      locations.each { |pb_number| puts "  #{pb_number.feature_file.path}:#{pb_number.line_number}" }
    end
  end

  class PBNumber
    include Comparable

    attr_reader :major, :minor, :feature_file, :line_number

    def initialize( number_string, feature_file, number )
      @number_string = number_string
      @number_string =~ /PB(\d+)-(\d+)/
      @major, @minor = $1, $2 #temp storage, since next regex will clear these globals
      @major = Integer( @major.sub(/\A0+/,'') ) #strips off leading zero for integer conversion to work
      @minor = Integer( @minor.sub(/\A0+/,'') )
      @feature_file = feature_file
      @line_number = number
    end

    def <=>(other)
      return @major <=> other.major unless (@major <=> other.major) == 0
      @minor <=> other.minor
    end

    def to_s
      @number_string
    end

    def self.collect( file_or_directory = FeatureFile::FEATURES_DIR )
      FeatureFile.scan(file_or_directory).flat_map { |file| file.pb_numbers }
    end
  end

 class FeatureFile
    include Comparable

    attr_reader :name, :path

    FEATURES_DIR = File.join( Rails.root, 'features')

    def initialize( file_path )
      self.file_path = file_path
    end

    def file_path=( file_path )
      @path = file_path
      @name = @path.split("/").last
    end

    def pb_numbers
      @pb_numbers ||= compute_pb_numbers
    end

    def <=>(other)
      @name <=> other.name
    end

    def to_s
      @name
    end

    def self.scan( file_or_directory )
      feature_files = if File.file?( file_or_directory )
        feature_files = FeatureFile.new( file_or_directory )
      else
        Dir["#{file_or_directory}/*/**/*.feature"].map { |file_path| FeatureFile.new( file_path ) }
      end
    end

  protected
    def compute_pb_numbers
      pb_numbers = []
      File.readlines( @path ).each_with_index do |line, number|
        if line =~ /@(PB|EE)/
          pb_numbers << PBNumber.new( line.strip[1..-1], self, number+1 ) # drop the @
        end
      end
      pb_numbers
    end
  end
end

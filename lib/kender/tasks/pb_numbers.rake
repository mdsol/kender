require 'find'

namespace :pb do
  desc "finds duplicate PB numbers"
  task :duplicates do

    all = PBNumber.collect.inject( Hash.new(0) ) do | memo, pb_number |
      memo[pb_number.to_s] = [] if memo[pb_number.to_s] == 0
      memo[pb_number.to_s] << pb_number
      memo
    end

    duplicates = all.reject { | k, v | v.length == 1 }

    duplicates.each_value do | duplicate |
      duplicate.each do | pb_number|
        puts pb_number.feature_file.name + ": " + pb_number.to_s
      end
    end
  end

  class PBNumber
    include Comparable

    attr_reader :major, :minor, :feature_file

    def initialize( number_string, feature_file )
      @number_string = number_string
      @number_string =~ /PB(\d+)-(\d+)/
      @major, @minor = $1, $2 #temp storage, since next regex will clear these globals
      @major = Integer( @major.sub(/\A0+/,'') ) #strips off leading zero for integer conversion to work
      @minor = Integer( @minor.sub(/\A0+/,'') )
      @feature_file = feature_file
    end

    def <=>(other)
      return @major <=> other.major unless (@major <=> other.major) == 0
      @minor <=> other.minor
    end

    def to_s
      @number_string
    end

    def self.collect( file_or_directory = FeatureFile::FEATURES_DIR )
      pb_numbers = []
      FeatureFile.collect( file_or_directory ).each do | file |
        pb_numbers << file.pb_numbers
      end
      pb_numbers.flatten
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
      return @pb_numbers unless @pb_numbers.nil?
      @pb_numbers = []
      File.read( @path ).each_line do |line|
        if line =~ /@(PB|EE)/
          @pb_numbers << PBNumber.new( line.strip[1..-1], self ) # drop the @
        end
      end
      @pb_numbers
    end

    def <=>(other)
      @name <=> other.name
    end

    def to_s
      @name
    end

    def self.collect( file_or_directory )
      feature_files = []
      if File.file?( file_or_directory )
        feature_files = FeatureFile.new( file_or_directory )
      else
        Find.find( file_or_directory ) do | file_path |
         unless File.directory?( file_path ) || ( file_path !~ /.+\.feature$/ )
            file = FeatureFile.new( file_path )
            feature_files << file
          end
        end
      end
      feature_files
    end
  end
end

class Kender::Coverage
  def initialize
  end

  def self.report
    self.new.test
  end

  def code_files
    return @code_files if @code_files
    @code_files = `find app lib -type f -name "*.rb"`.split(/\n/)
    @code_files.delete_if do |filename|
      excluded = false
      exclusions.each do |pattern|
        if pattern.match(filename)
          excluded = true; break
        end
      end
      excluded
    end
  end

  #TODO: needs to be per-app config.
  def exclusions
    [/^app\/admin/]
  end
  
  def spec_files
    @spec_files ||= `find spec -type f`.split(/\n/)
  end
  
  def spec_file_for_code_file(code_filename)
    pattern = Regexp.new(code_filename.split('/').last[0..-4])
    spec_files.grep(pattern).first
  end

  def method_list
    return @method_list if @method_list
    @method_list = {}
    code_files.each do |filename|
      pattern = /^.* def ([^ \(]+).*$/
      method_list[filename] = File.read(filename).split(/\n/).grep(pattern)
      method_list[filename].map! { |method_signature| method_signature.gsub(pattern, '\1') }
    end
    @method_list
  end
  
  def test
    score, max_score = 0, 0
    code_files.each do |filename|
      max_score += method_list[filename].size # each methods count for one.
      spec_file = spec_file_for_code_file(filename)
      if spec_file && File.exist?(spec_file)
        method_list[filename].each do |method_name|
          score += 1 if `grep -rn "describe.*#{method_name}" #{spec_file}`.size > 0
        end
      else
        puts "rspec file for #{filename} could not be found."
      end
    end
    puts "Kender Code Coverage Report: #{score}/#{max_score}"
  end
end



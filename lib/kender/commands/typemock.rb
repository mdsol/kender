module Kender
  class Typemock < Command
    @@progFiles = File.join("C:", "Program Files (x86)")

    def initialize
        command = "#{tmockrunner} #{mstest}"

        super(command)
    end

    # we only run shamus if the we are told so
    def available?
      #this is slow as bundle exec can prove to be quite slow in old rubies
      return false if (!mstest || !tmockrunner)
      true
    end

    def run(command)
      p 'in run'
      success = true
      assemblies.each do |x|
        runCmd = command + " /testcontainer:" + x.inspect
        p runCmd
        system(runCmd)
        success = $?.success? if success
      end

      Kender::Command::Result.new success
    end

    #def execute
    #  if !run(@command)
    #    raise RuntimeError, "Command failed: #{@command}"
    #  end
    #end

    def assemblies
      testsDlls = Dir[File.join(Dir.pwd, "**/*Tests.dll")]
      testDlls = Dir[File.join(Dir.pwd, "**/*Test.dll")]
      (testsDlls + testDlls).delete_if {|x| (!x.include? "bin/Debug") || (x.include? "TestResults")}
    end

    def mstest
      path = Dir[File.join(@@progFiles, "Microsoft Visual Studio " + (ENV['MSTEST_VERSION'] || '10.0'), \
        "**/mstest.exe")].first

      path.inspect if path and File.exists? path
    end

    def tmockrunner
      path = Dir[File.join(@@progFiles, "Typemock", "Isolator", (ENV['TMOCKRUNNER_VERSION'] || '6.1'), \
        "**/tmockrunner.exe")].first

      path.inspect if path and File.exists? path
    end
  end
end

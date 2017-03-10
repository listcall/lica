base = File.dirname(File.expand_path(__FILE__))
Dir.glob("#{base}/lib/*").each {|ext_file| require ext_file}
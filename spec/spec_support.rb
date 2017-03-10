# spec-wide support methods

def klas
  described_class
end

def included_in(*spec_files)
  target_files = RSpec.configuration.files_to_run
  spec_files.each do |spec_file|
    spec_tgt = 'spec/' + spec_file
    require spec_tgt unless target_files.include?(spec_tgt + '.rb')
  end
end

require 'yaml'

class Preamble
  attr_accessor :metadata, :content

  def initialize(metadata, content)
    @metadata = metadata
    @content = content
  end

  def metadata_with_content
    @metadata.to_hash.to_yaml + "---\n" + @content
  end

  def save(path)
    open(path) do |f|
      f.write metadata_with_content
    end
  end

  # load from file
  def self.load(path)
    import(File.read(path))
  end

  # import text variable
  def self.import(text)
    preamble_lines = String.new
    content_lines = String.new

    state = :before_preamble

    text.each_line do |line|
      stripped = line.strip

      case state
      when :before_preamble
        new_state = case stripped
                    when '---'
                      :preamble
                    when ''
                      :before_preamble
                    else
                      # raise "First line must begin with ---"
                      content_lines << line
                      :after_preamble
                    end
      when :preamble
        new_state = case stripped
                    when '---'
                      :after_preamble
                    else
                      preamble_lines << line
                      :preamble
                    end
      when :after_preamble
        new_state = :after_preamble
        content_lines << line
      else
        raise "Invalid State: #{ state }"
      end
      state = new_state
    end
    new(YAML::load(preamble_lines), content_lines)
  end
end

# integration_test: features/admin/svc_reps

require 'yaml'
require 'preamble'
require_relative 'template_common'

class Rep::TemplateFs

  include Rep::TemplateCommon

  TFILE_DIR ||= "#{Rails.root.to_s}/app/models/rep/templates"

  attr_reader :name, :opts, :cfgs

  def initialize(name = '_base')
    @name = name
    raise "Unknown Report Template: #{name}" unless File.exist?(template_path)
    @opts = base_opts.merge(template_opts).with_indifferent_access
    @cfgs = base_cfgs.merge(template_cfgs).with_indifferent_access
    raise 'Undefined context' unless cfgs[:context_type].present?
  end

  # ----- class methods -----

  class << self
    def tfile_dir
      TFILE_DIR
    end

    def fetch(id)
      self.new(id)
    end
  end

  # ----- instance methods -----

  alias_method :id, :name

  def opt_merge(new_opts)
    @opts = @opts.merge(new_opts)
  end

  def text
    File.read template_path
  end

  def content_w_opts
    opts_block = opts.empty? ? '' : "#{opts.to_hash.to_yaml}---\n"
    opts_block + content
  end

  def destroy
    'OK'
  end

  private

  def template_path
    "#{TFILE_DIR}/#{name}.hbs"
  end

  def preamble
    @pre ||= Preamble.load(template_path)
  end
end
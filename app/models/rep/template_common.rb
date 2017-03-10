# integration_test: models/rep/template_db models/rep/template_fs
# integration_test: features/admin/svc_reps

module Rep::TemplateCommon

  # ----- associations -----
  def reps
    svt = Rep.arel_table
    Rep.where(svt[:base_template_id].eq(id_s).
                or(svt[:fork_template_id].eq(id_s))).to_a
  end
  alias_method :reports, :reps

  def origin_rep
    Rep.where(fork_template_id: id_s).to_a.first
  end

  def dependent_reps
    Rep.where(base_template_id: id_s).to_a
  end

  def content
    preamble.content
  end
  alias_method :template_content, :content

  def ctx_json
    ctx_klas = cfgs[:context_type].constantize
    ctx      = ctx_klas.new(opts)
    ctx.ctx.to_json
  end

  def id_s; self.id.to_s; end
  def to_i; self.id     ; end

  private

  def base_opts
    {}
  end

  def base_cfgs
    {}
  end

  def metadata
    @metadata ||= (preamble.metadata || {}).with_indifferent_access
  end

  def template_opt_keys
    metadata.keys.select {|key| key[0] != '_'}
  end

  def template_cfg_keys
    metadata.keys.select {|key| key[0] == '_'}
  end

  def template_opts
    metadata.slice(*template_opt_keys).with_indifferent_access
  end

  def template_cfgs
    data1 = metadata.slice(*template_cfg_keys)
    data2 = data1.keys.reduce({}) {|acc, key| acc[key[1..-1]] = data1[key]; acc}
    data2.with_indifferent_access
  end
end
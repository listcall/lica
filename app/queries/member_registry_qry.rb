class MemberRegistryQry

  attr_reader :team, :params, :filter, :qry

  def initialize(team, params)
    @team   = team
    @params = params
  end

  def qry
    @qry ||= gen_query
  end

  def to_a
    qry.standard_order
  end

  def to_s
    return 'none' if filter.blank?
    filter.to_s.gsub(/[{}:"]/,'')
  end

  private

  def gen_filters
    @filter = {}
    @filter[:ranks]  = params_to_a(params['ranks'])              if params['ranks']
    @filter[:roles]  = params_to_a(params['roles'])              if params['roles']
    @filter[:rights] = params_to_a(params['rights'], 'downcase') if params['rights']
    @filter
  end

  def gen_query
    flt = gen_filters
    qry = team.memberships.includes(:user)
    qry = qry.where(rights: flt[:rights])             unless flt[:rights].blank?
    qry = qry.where(rank:   flt[:ranks])              unless flt[:ranks].blank?
    qry = qry.where('ARRAY[?] && roles', flt[:roles]) unless flt[:roles].blank?
    qry
  end

  def params_to_a(string, txt_case = 'upcase')
    return nil if string.blank?
    string.split(',').map {|x| eval("x.strip.#{txt_case}")}
  end

end
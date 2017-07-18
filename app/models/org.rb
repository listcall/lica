class Org < ActiveRecord::Base

  ALT_DOMAINS ||= {
    # VM hostnames: devlica (development), tstlica (staging)
    # use smso.dev, lica.dev, lica.vdev for development
    # use smso.tst, lica.tst, lica.vtst for staging
    'listcall.net' => %w(smso.dev smso.tst lica.dev lica.tst lica.vdev lica.vtst)
  }

  # for development - a mapping of dev domains with their production equivalents
  DEV_HOST_WITH_PORT ||= {
    'listcall.net' => 'smso.dev:3000'
  }

  # ----- Attributes -----

  # ----- Associations -----
  has_many    :teams,    :dependent  => :destroy
  belongs_to  :org_team, :class_name => 'Team'

  # ----- Validations -----
  validates :typ, :presence => true
  validates :typ, :format   => { :with => /enterprise|hosting|system/ }

  validates_presence_of    :name, :domain
  validates_uniqueness_of  :name, :domain, :org_team_id

  validates_with TeamAltDomainValidator

  # ----- Callbacks -----

  # ----- Scopes -----

  def self.fallback
    where(fallback: true).first
  end

  def self.by_domain(domain)
    where(:domain => domain)
  end

  # ----- Class Methods ----

  class << self
    def base_domain(domain)
      inverted_map[domain] || domain
    end

    private

    def inverted_map
      @inverted_map ||= ALT_DOMAINS.reduce({}) {|h, (k,v)| v.map{|f| h[f] = k}; h}
    end
  end

  # ----- Instance Methods -----

  def host_with_port
    return self.domain unless Rails.env.development? || Rails.env.test?
    DEV_HOST_WITH_PORT.fetch(self.domain) {|_el| self.domain}
  end
  alias_method :domain_with_port, :host_with_port

  def set_as_fallback
    Org.where(fallback: true).to_a.each do |acc|
      acc.update_attributes fallback: false
    end
    self.update_attributes fallback: true
  end

end

# == Schema Information
#
# Table name: orgs
#
#  id          :integer          not null, primary key
#  uuid        :uuid
#  typ         :string(255)
#  name        :string(255)
#  domain      :string(255)
#  org_team_id :integer
#  fallback    :boolean          default(FALSE)
#  created_at  :datetime
#  updated_at  :datetime
#

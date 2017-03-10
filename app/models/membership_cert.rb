require 'forwardable'

class MembershipCert < ActiveRecord::Base

  extend Forwardable
  # has_paper_trail

  # ----- Attributes -----

  # ----- Associations -----
  belongs_to :membership,  :touch => true
  belongs_to :user_cert ,  :touch => true
  belongs_to :qual_ctype,  :touch => true

  alias_method :ctype   ,  :qual_ctype

  # ----- Validations -----
  validates :title   , length: {in: 2..30 }

  # ----- Callbacks -----

  # ----- Scopes -----
  scope :sorted    , -> { order('position ASC')                }
  scope :mc_expired, -> { where('mc_expires_at < ?', Time.now) }
  scope :attendance, -> { where(ev_type: 'attendance')         }
  scope :link      , -> { where(ev_type: 'link')               }
  scope :file      , -> { where(ev_type: 'file')               }

  # ----- Class Methods ----

  # ----- Instance Methods -----
  def is_link?
    self.ev_type == 'link'
  end

  def is_file?
    self.ev_type == 'file'
  end

  def is_attendance?
    self.ev_type == 'attendance'
  end

  def current?
    expires_at && (expires_at > Time.now)
  end

  def expired?
    expires_at && (expires_at < Time.now)
  end

  # ----- delegated methods -----
  def expires_at
    self.mc_expires_at || (user_cert && user_cert.expires_at)
  end

  def attachment
    user_cert && user_cert.attachment
  end

  def link
    user_cert && user_cert.link
  end

  def comment
    user_cert.try(:comment)
  end

end

# == Schema Information
#
# Table name: membership_certs
#
#  id            :integer          not null, primary key
#  membership_id :integer
#  qual_ctype_id :integer
#  position      :integer
#  user_cert_id  :integer
#  status        :string(255)
#  reviewer_id   :integer
#  reviewed_at   :string(255)
#  external_id   :string(255)
#  xfields       :hstore           default("")
#  created_at    :datetime
#  updated_at    :datetime
#  title         :string(255)
#  mc_expires_at :datetime
#  ev_type       :string(255)
#

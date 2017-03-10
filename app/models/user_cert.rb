require 'app_auth/methods'

class UserCert < ActiveRecord::Base

  # has_paper_trail

  # ----- Attributes -----
  has_attached_file :attachment,
                    path: ':rails_root/public/system/:class/:cert_user_id/:attachment/:id_partition/:style/:filename',
                    url:                    '/system/:class/:cert_user_id/:attachment/:id_partition/:style/:filename'

  joinup = ->(arr, hdr) { arr.map {|x| "#{hdr}/#{x}"} }
  mime_img = joinup.call %w(jpeg jpg gif tiff png), 'image'
  mime_app = joinup.call %w(pdf msword), 'application'
  mime_all = mime_img + mime_app
  validates_attachment_content_type :attachment, content_type: mime_all

  before_post_process :cleanup_attachment_file_name

  # ----- Associations -----
  belongs_to :user             ,  :touch => true
  has_many   :membership_certs ,  :dependent => :destroy

  # ----- Validations -----

  validates :comment , length: {maximum: 60  }
  validates :link    , length: {maximum: 100 }

  # ----- Callbacks -----

  # ----- Scopes -----

  # ----- Class Methods ----

  # ----- Instance Methods -----

  def cleanup_attachment_file_name
    self.attachment.instance_write(:file_name, "#{self.attachment_file_name.gsub(' ','_')}")
  end

end

# == Schema Information
#
# Table name: user_certs
#
#  id                        :integer          not null, primary key
#  user_id                   :integer
#  comment                   :string(255)
#  link                      :string(255)
#  attachment_file_name      :string(255)
#  attachment_file_size      :string(255)
#  attachment_content_type   :string(255)
#  attachment_updated_at     :string(255)
#  expires_at                :datetime
#  ninety_day_notice_sent_at :datetime
#  thirty_day_notice_sent_at :datetime
#  expired_notice_sent_at    :datetime
#  xfields                   :hstore           default("")
#  created_at                :datetime
#  updated_at                :datetime
#

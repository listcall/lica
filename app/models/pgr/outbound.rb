require 'app_ext/pkg'
require 'forwardable'

class Pgr::Outbound < ActiveRecord::Base

  extend Forwardable

  # ----- Attributes -----
  xfield_accessor :stored_subject

  # ----- Associations -----
  belongs_to :post   , :class_name => 'Pgr::Post', :foreign_key => :pgr_post_id
  belongs_to :target , :class_name => 'Membership'
  belongs_to :email  , :class_name => 'User::Email'
  belongs_to :phone  , :class_name => 'User::Phone'

  def dialog    ; @dialog    ||= post.try(:dialog) ;  end
  def broadcast ; @broadcast ||= dialog.broadcast  ;  end
  def pgrs      ; @pgr       ||= broadcast.pgrs    ;  end

  # ----- Delegated Methods -----
  def_delegators :post, :num_posts

  def author; post.try(:author); end
  def target; post.try(:target); end

  # ----- Callbacks -----

  # ----- Scopes -----
  scope :pending,    -> { where('sent_at is NULL')          }
  scope :sent,       -> { where('sent_at is not NULL')      }
  scope :recent,     -> { order('sent_at DESC')             }
  scope :phone,      -> { where(target_channel: 'phone')    }
  scope :email,      -> { where(target_channel: 'email')    }

  # ----- Local Methods -----

  def team
    dialog.try(:broadcast).try(:team)
  end

  def team_domain
    team.try(:fqdn)
  end

  def post_id
    post.message_id
  end

  def dialog_peers
    dialog.outbounds
  end

  def deliver
    raise 'Implement in subclass'
  end

  def sent?
    sent_at.present?
  end
end

# == Schema Information
#
# Table name: pgr_outbounds
#
#  id             :integer          not null, primary key
#  type           :string
#  pgr_post_id    :integer
#  target_id      :integer
#  device_id      :integer
#  device_type    :string
#  target_channel :string
#  origin_address :string
#  target_address :string
#  bounced        :boolean          default("false")
#  xfields        :hstore           default("")
#  sent_at        :datetime
#  read_at        :datetime
#  created_at     :datetime
#  updated_at     :datetime
#

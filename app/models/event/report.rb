class Event::Report < ActiveRecord::Base

  # ----- Attributes -----
  store_accessor :data, :unit_leader, :signed_by, :description

  # ----- Associations -----
  belongs_to :period, touch: true, foreign_key: 'event_period_id', class_name: 'Event::Period'

  # ----- Callbacks -----

  # ----- Validations -----

  # ----- Scopes -----
  scope :smso_aars,           -> { where(typ: 'smso_aar')           }
  scope :internal_aars,       -> { where(typ: 'internal_aar')       }
  scope :blog_posts,          -> { where(typ: 'blog_post')          }
  scope :contact_list,        -> { where(typ: 'contact_list')       }
  scope :training_packet,     -> { where(typ: 'training_packet')    }

  # ----- Local Methods-----
  def event
    period.event
  end

  def event_date
    period.event.start
  end

  def template
    case self.typ
      when 'smso_aar'     then 'smso_aar.html'
      when 'internal_aar' then 'internal_aar.html'
      else 'unknown.html'
    end
  end

end

# == Schema Information
#
# Table name: event_reports
#
#  id              :integer          not null, primary key
#  typ             :string(255)
#  event_period_id :integer
#  title           :string(255)
#  position        :integer
#  data            :hstore           default("")
#  published       :boolean          default("false")
#  created_at      :datetime
#  updated_at      :datetime
#

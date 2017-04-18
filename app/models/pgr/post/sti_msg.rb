class Pgr::Post::StiMsg < Pgr::Post

  # ----- Associations -----
  change_association :dialog, class_name: 'Pgr::Dialog::AsPaging'

  # ----- Callbacks -----
  before_create :mark_posted

  # ----- Instance Methods -----

  private

  def mark_posted
    # (true) reloads the association...
    dialog().try(:mark_posted, self.author_id)
    dialog().try(:mark_read_thread, self.author_id)
  end

end

# == Schema Information
#
# Table name: pgr_posts
#
#  id              :integer          not null, primary key
#  type            :string
#  pgr_dialog_id   :integer
#  author_id       :integer
#  target_id       :integer
#  short_body      :text
#  long_body       :text
#  action_response :string
#  bounced         :boolean          default("false")
#  ignore_bounce   :boolean          default("false")
#  sent_at         :datetime
#  read_at         :datetime
#  xfields         :hstore           default("")
#  jfields         :jsonb            default("{}")
#  created_at      :datetime
#  updated_at      :datetime
#

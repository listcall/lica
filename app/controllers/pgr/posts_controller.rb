# integration_test: requests/pgr/interaction

# all the posts for a dialog...
class Pgr::PostsController < ApplicationController

  before_action :authenticate_reserve!, :except => :pixel

  def index
    @assig  = load_assignment
    @dialog = load_dialog
    @post   = build_post
    dev_log @post
    @dialog.mark_read_thread(current_membership.id)
  end

  def create
    dial_id  = params[:pgr_post][:pgr_dialog_id]
    dialog   = ::Pgr::Dialog.find_by(id: dial_id)
    # TODO - run this in background
    author_opts = {author_channel: "web"}
    Pgr::Util::GenReply.new(dialog, params[:pgr_post], author_opts).deliver_all
    redirect_to "/paging/#{params[:b_id]}/for/#{dial_id}"
  end

  def pixel
    dialog    = ::Pgr::Dialog.find(params["d_id"])
    member    = Membership.find(params["m_id"])
    icon_path = Rails.root.to_s + "/public" + dialog.broadcast.sender.team.icon_path.split('?').first
    # TODO: mark thread red in background
    dialog.mark_read_thread(member.id)
    send_data open(icon_path, "rb") { |f| f.read }
  end

  private

  # ----- assignment -----

  def load_assignment
    @assig_container ||= dialog_conf.assignment_for(params[:b_id])
  end

  # ----- dialog -----

  def load_dialog
    @dialog_container ||= dialog_scope.find(params[:d_id])
  end

  def dialog_scope
    incl = [:recipient, :broadcast, {:broadcast => [:sender, :action]}]
    load_assignment.broadcast.dialogs.includes(incl)
  end

  # ----- post -----

  def build_post
    @post_container = load_dialog.posts.becomes(Pgr::Post::StiMsg).build
  end

  # ----- misc -----

  def dialog_conf
    @conf_container ||= VwDialogs.new(current_team)
  end
end

# integration_test: features/pgr/reply
# integration_test: requests/pgr/multi_partner

require 'ext/ar_proxy'

class Pgr::DialogsController < ApplicationController

  before_action :authenticate_reserve!

  def index
    @assig   = load_assignment
    @dialogs = load_dialogs
  end

  private

  # ----- assignment -----

  def load_assignment
    @assig_container ||= dialog_conf.assignment_for(params[:b_id])
  end

  # ----- dialog -----

  def load_dialogs
    @dialogs_container ||= dialog_conf.dialogs_for(load_assignment)
  end

  # ----- misc -----

  def dialog_conf
    @conf_container ||= VwDialogs.new(current_team)
  end
end

class Ajax::EventParticipantsController < ApplicationController

  before_action :authenticate_reserve!

  respond_to :json, :html

  def index
    perid   = params[:event_period_id]
    @period = Event::Period.find(perid)
    respond_with @period.participants do |format|

      # noinspection RubyArgCount
      format.html { render 'event_periods/_participant_table', layout: false }
    end
  end

  def create
    @member = Membership.find(params[:mem_id])
    @period = Event::Period.find(params[:event_period_id])
    @target = get_period(@period, params)
    @participant = Event::Participant.where(event_period_id: @target.id, membership_id: @member.id).first_or_create
    table = params[:child] == 'true' ? '_child_table' : '_participant_table'
    respond_to do |format|
      # noinspection RubyArgCount
      format.html { render "event_periods/#{table}", layout: false }
      format.json { render :json => @period.participants           }
    end
  end

  def update
    field = params['name']
    value = params['value']
    participant = Event::Participant.find(params['id'])
    participant.update_attributes({field => value})
    row = participant.event.team == current_team ? 'participant_row' : 'child_row'
    # noinspection RubyArgCount
    if field == 'role'
      @period = participant.period
      render 'event_periods/_participant_table', layout: false
    else
      respond_to do |format|
        # noinspection RubyArgCount
        format.html { render "event_periods/_#{row}", locals: {participant: participant}, layout: false }
        format.json { render :json => @period.participants                     }
      end
    end
  end

  def destroy
    participant = Event::Participant.find(params[:id])
    respond_with participant.try(:destroy)           # TODO: return HTML with participant table and summary stats
  end

  private

  def get_period(base_period, params)
    return base_period unless params[:child] == 'true'
    base_period.children.find {|period| period.event.team.acronym == params[:team_acro]}
  end

end

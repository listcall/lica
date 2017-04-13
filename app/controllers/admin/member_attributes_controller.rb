class Admin::MemberAttributesController < ApplicationController

  before_action :authenticate_owner!

  def index
    @title = 'Member Attributes'
    @attributes = current_team.member_attributes.to_a
  end

  def create
    @attribute  = MemberAttribute.new(name: unique_name('TBD'), label: unique_label('TBD'), position: 0)
    if @attribute.valid?
      MemberAttributesSvc.new(current_team).add_obj(@attribute)
      redirect_to '/admin/member_attributes', notice: "Added #{@attribute.label}"
    else
      redirect_to '/admin/member_attributes', alert: 'There was an error creating the attribute...'
    end
  end

  def update
    MemberAttributesSvc.new(current_team).update(clean(params))
    render :plain => 'OK'
  end

  def destroy
    MemberAttributesSvc.new(current_team).destroy(params)
    redirect_to '/admin/member_attributes', :notice => "#{params[:id]} was deleted."
  end

  def sort
    MemberAttributesSvc.new(current_team).sort(params)
    render :plain => 'OK'
  end

  private

  def clean(params)
    val1 = params['value']
    val2 = params['name'] == 'label' ? unique_label(val1) : unique_name(val1)
    {
      'id'    => params['id'],
      'name'  => params['name'],
      'value' => val2
    }
  end

  def unique_name(seed)
    unique_string current_team.member_attributes.to_a.map {|x| x.name}, seed
  end

  def unique_label(seed)
    unique_string current_team.member_attributes.to_a.map {|x| x.label}, sanitize(seed)
  end

  def sanitize(label)
    punc = /[\\\/\,\?\=\+\`\~\'\"\;\:\<\>\*\&\^\%\$\#\@\!\(\)\[\]\{\}]/
    label.strip.gsub(' ', '_').gsub(punc,'')
  end

  def unique_string(strings, seed)
    return seed unless strings.include? seed
    idx = 1
    while (strings.include?("#{seed}#{idx}")) || idx > 100
      idx += 1
    end
    "#{seed}#{idx}"
  end

end

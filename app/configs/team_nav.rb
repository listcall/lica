require 'app_config/model'

class TeamNav < AppConfig::Model

  model_accessor :type, :path, :label, :admin, :director, :owner, :manager, :active, :reserve, :guest, :alum
  id_uuid

  validates_presence_of :type, :path, :label, :owner, :manager, :active, :reserve, :guest, :alum

  validates :owner     , :format => { :with => /show|hide/ }
  validates :manager   , :format => { :with => /show|hide/ }
  validates :active    , :format => { :with => /show|hide/ }
  validates :reserve   , :format => { :with => /show|hide/ }
  validates :guest     , :format => { :with => /show|hide/ }
  validates :alum      , :format => { :with => /show|hide/ }

  def default_values
    {
        type: '<custom>',
        path:     '/',
        label:    'TBD',
        owner:    'show',
        manager:  'show',
        active:   'show',
        reserve:  'show',
        guest:    'hide',
        alum:     'hide'
    }
  end

end

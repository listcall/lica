class Admin::DataImportController < ApplicationController

  before_action      :authenticate_member!

  def index
    @importers = [
      CfgXcertTypeImporter,
      CfgMemberRankImporter,
      CfgMemberRoleImporter,
      CfgMemberAttributeImporter,
      CfgEventAttributeImporter,
      CfgEventRoleImporter,
      CfgEventTypeImporter,
      MembershipImporter,
      MembershipXcertImporter,
      UserPhoneImporter,
      UserEmailImporter,
      UserAddressImporter,
      UserEmergencyContactImporter,
      EventImporter,
      EventPeriodImporter,
      EventParticipantImporter,
      ForumImporter
      ]
    @name_links = @importers.map do |klas|
      name = klas.to_s.gsub('Importer', '') + 's'
      "<a href='##{name}'>#{name}</a>"
    end.join(' | ')
    @doccos     = @importers.map {|klas| Common::ImporterDoc.new(klas)}
    @overviews  = @doccos.map {|x| x.overview}
  end

end

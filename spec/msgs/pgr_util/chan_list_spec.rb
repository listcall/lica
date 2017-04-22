require 'rails_helper'

describe PgrUtil::ChanList do

  include_context "Integration Environment"

  let(:bcst) do
    bc = Pgr::Broadcast::AsPagingCreate.create(bcst_params)
    Pgr::Util::GenBroadcast.new(bc).generate_all.deliver_all
    bc
  end

  # let(:klas)    { described_class                                 }
  # let(:subject) { klas.new(bcst.dialogs.first, post_params)       }
  # let(:rep_svc) { klas.new(bcst.dialogs.first, post_params)       }

  # def bcst_params
  #   {
  #     'sender_id'              => sendr.id,
  #     'short_body'             => 'Hello World',
  #     'long_body'              => 'Hello Long Body World',
  #     'email'                  => true,
  #     'sms'                    => true,
  #     'recipient_ids'          => [recp1.id],
  #     'assignments_attributes' => [{'pgr_id' => pagr1.id}]
  #   }
  # end
end
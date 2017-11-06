module Services
  module Member
    class Load < Services::Base
      attr_accessor :coin_id,
                    :member_id,
                    :quantity,
                    :initial_btc_rate

      validates :coin_id,
                :member_id,
                :quantity,
                :initial_btc_rate,
                presence: true

      alias :aggregate_id :member_id
    end
  end
end

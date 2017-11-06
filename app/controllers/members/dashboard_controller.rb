# frozen_string_literal: true

module Members
  class DashboardController < ApplicationController
    def index
      @purchases = current_member.purchase_history
      @transactions = current_member.transaction_history
    end
  end
end

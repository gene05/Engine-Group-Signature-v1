module Signature
  class ApplicationController < ActionController::Base

    private

    def order
      params[:column] || 'updated_at'
    end

    def direction
      params[:direction] || 'desc'
    end

    def page
      params[:page] || 0
    end

  end
end

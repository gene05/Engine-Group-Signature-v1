require 'rails_helper'

module Signature
  describe SignaturesController do

    describe "GET 'trips'" do
      it "returns http success" do
        get 'trips'
        response.should be_success
      end
    end

  end
end

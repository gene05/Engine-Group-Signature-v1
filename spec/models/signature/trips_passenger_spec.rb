require 'rails_helper'

module Signature
  describe TripsPassenger do
    
    it "should create hased id after create" do
      t = FactoryGirl.create(:trips_passenger)
      t.hashed_id.should_not == nil
    end
  end
end

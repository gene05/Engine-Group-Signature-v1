module Signature
  class TripsPassenger < ActiveRecord::Base
    has_many :trips
    has_many :passengers

    after_create :set_hash

    def set_hash
      self.update_attribute(:hashed_id, Digest::SHA2.hexdigest(self.id.to_s))
    end

  end
end

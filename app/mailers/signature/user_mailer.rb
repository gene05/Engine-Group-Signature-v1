module Signature
  class UserMailer < ApplicationMailer

    def send_documents(passenger, reference)
      @trip_passenger = TripsPassenger.where(:hashed_id => reference).last
      @trip = Trip.where(id: @trip_passenger.trip_id).last
      @count_documents = DocumentsPassenger.pending_to_signs(@trip_passenger.trip_id, passenger.id).count
      @passenger = passenger
      base_url = "#{ActionMailer::Base.default_url_options[:host]}#{(':' + ActionMailer::Base.default_url_options[:port]) if ActionMailer::Base.default_url_options[:port] == '3000'}"
      @url = "http://#{base_url}/d/#{reference}"
      mail(to: passenger.email, subject: 'To sign documents')
    end

  end
end

module Signature
  class Document < ActiveRecord::Base
    has_many :documents_passengers

    scope :list_by_page, ->(page, column, direction) {order(column+' '+direction).page(page).per(5)}

    def format_date
      updated_at.strftime("%d/%m/%Y") if updated_at
    end

    def format_content(passenger)
      content.gsub('{{@NAME@}}', passenger_name(passenger)).html_safe if content
    end

    def passenger_name(passenger)
      passenger ? passenger.name.titleize : ''
    end

  end
end

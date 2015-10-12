module Signature
  class ManagerOrderStatus
    def initialize(method, column, direction)
      @method = method
      @column = column
      @direction = direction
    end

    def list_method
      if @column == "number"
        (order_list(with_status_true, with_status_false) + with_status_true_and_false + order_list(with_status_false, with_status_true) + without_status).first(10)
      else
        @method.list_by_name
      end
    end

    def order_list(first_record, secound_record)
      @direction == "desc" ? first_record - with_status_true_and_false : secound_record - with_status_true_and_false      
    end

    def with_status_true_and_false
      with_status_true & with_status_false
    end

    def with_status_true
      @method.all_by_status.where('documents_passengers.status="t"')
    end

    def with_status_false
      @method.all_by_status.where('documents_passengers.status="f"')
    end

    def without_status
      @method.all_by_status.where('documents_passengers.status is null')
    end

  end
end

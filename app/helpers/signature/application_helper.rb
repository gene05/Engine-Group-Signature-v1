module Signature
  module ApplicationHelper
    def sortable(column, title = nil)
      title ||= column.titleize
      direction = (column == params[:column] && params[:direction] == "desc") ? "asc" : "desc"
      page = params[:page] ? params[:page] : 1
      link_to :column => column, :direction => direction, :page => page do
        content_tag(:i,"", :class => ["tablesorter-icon", "bootstrap-icon-unsorted", "#{direction}"])
      end
    end

  end
end

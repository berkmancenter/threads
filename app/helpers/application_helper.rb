# frozen_string_literal: true
module ApplicationHelper
  def flash_class(level)
    case level
    when 'notice' then 'alert alert-info'
    when 'success' then 'alert alert-success'
    when 'error' then 'alert alert-warning'
    when 'alert' then 'alert alert-danger'
    end
  end
end

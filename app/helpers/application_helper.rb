module ApplicationHelper
 def flash_class(level)
    case level.to_sym
    when :notice then "warning-alert"
    when :success then "alert alert-success"
    when :error then "danger-alert"
    when :alert then "danger-alert"
    end
  end
end

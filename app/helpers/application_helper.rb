module ApplicationHelper
  # Called when deciding colors for alert badge
  def bootstrap_class_for(flash_type)
    case flash_type
    when 'success', 'notice'
      'alert-success'   # Green
    when 'error', 'alert'
      'alert-danger'    # Red
    when 'warning'
      'alert-warning'   # Yellow
    else
      flash_type.to_s
    end
  end

end

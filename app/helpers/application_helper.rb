module ApplicationHelper

  # Called when deciding colors for alert badge
  def bootstrap_class_for(flash_type)
    case flash_type
      when "success"
        "alert-success"   #Green
      when "error"
        "alert-danger"    #Red
      when "alert"
        "alert-danger"   #Yellow
      when "notice"
        "alert-success"  #Green
      else
        flash_type.to_s
    end
  end



end

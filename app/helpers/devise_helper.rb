module DeviseHelper
  def devise_error_messages!
    return "" unless devise_error_messages?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg.downcase.capitalize) }.join
    sentence = I18n.t("errors.messages.not_saved",
                      :count => resource.errors.count,
                      :resource => resource.class.model_name.human.downcase)

    html = <<-HTML
    <div class="card devise-error-card-margin-top">
      <div class="card-status bg-danger"></div>
      <div class="card-header">
        <h3 class="page-title">#{sentence}</h3>
      </div>
      <div class="card-body devise-error-card-padding">
        <ul>#{messages}</ul>
      </div>
    </div>
    HTML

    html.html_safe
  end

  def devise_error_messages?
    !resource.errors.empty?
  end

end


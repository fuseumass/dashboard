Recaptcha.configure do |config|
    if ENV['RAILS_ENV'] == 'production'
        config.site_key  = ENV['RECAPTCHA_SITE_KEY']
        config.secret_key = ENV['RECAPTCHA_SECRET_KEY']
    else
        config.site_key = 'development_site_key'
        config.secret_key = 'development_secret_key'
        config.skip_verify_env << 'development'
    end
end
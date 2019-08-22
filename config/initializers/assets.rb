# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

Rails.application.config.assets.paths << Rails.root.join("hackathon-config", "assets", "images")
Rails.application.config.assets.paths << Rails.root.join("hackathon-config", "assets", "stylesheets")
Rails.application.config.assets.paths << Rails.root.join("hackathon-config", "assets", "javascripts")

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( event_application.js )
# Manually add PNG and CSS files in the custom hackathon-config assets folders
Rails.application.config.assets.precompile += ['*.png']
Rails.application.config.assets.precompile += %w( custom.css custom.js )


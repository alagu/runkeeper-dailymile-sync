Rails.application.config.middleware.use OmniAuth::Builder do
  provider :dailymile, ENV['DAILYMILE_CLIENT_ID'], ENV['DAILYMILE_CLIENT_SECRET']
end

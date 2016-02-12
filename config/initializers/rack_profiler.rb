if Rails.env.devlopment?
  Rack::MiniProfiler.config.position = 'right'
end
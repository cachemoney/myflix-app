CarrierWave.configure do |config|
  config.fog_credentials = {
		provider: 'AWS',                       # required
		aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],    # required
		aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]	# required
  }
	config.fog_directory  = 'my-flix-rpaul'                     # required

	if Rails.env.test?
	  config.storage = :file
	  config.enable_processing = false
	else
		config.storage = :fog
	end

end
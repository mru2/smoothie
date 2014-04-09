require 'soundcloud_client'

soundcloud_params = YAML.load_file(File.join(ENV['APP_ROOT'], 'config', 'soundcloud.yml'))[ENV["RACK_ENV"]]

# Symbolizing keys
soundcloud_params.keys.each{|key|soundcloud_params[key.to_sym] = soundcloud_params.delete(key)}

$soundcloud = Smoothie::SoundcloudClient.new(soundcloud_params)
redis_params = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'redis.yml'))[ENV["RACK_ENV"]]

$redis = Redis.new(redis_params)
Resque.redis = $redis
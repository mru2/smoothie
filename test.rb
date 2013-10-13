# ENV RESTART : remake the dump

USER_ID = 2339203
DUMP_FILE = 'test.dump'
RESULT_FILE = 'public/test.json'

require './config/environment.rb'
require 'user'
require 'recommender_engine'

$redis = Redis.new(YAML.load_file(File.join(File.dirname(__FILE__), 'config', 'redis.yml'))['production'])



puts "Starting..."

start  = Time.now
user   = Smoothie::User.new(USER_ID)

if ENV['RESTART']
	engine = Smoothie::RecommenderEngine::Engine.new(user, 'debug' => true)
	File.open(DUMP_FILE, 'w').tap do |f|
		f.write(engine.dump)
		f.close
	end
else
	engine_dump = File.open(DUMP_FILE, 'r').read
	engine = Smoothie::RecommenderEngine::Engine.new(user, 'debug' => true, 'dump' => engine_dump)
end

puts "Engine started in #{Time.now - start} secs"
start = Time.now

engine.score!

puts "Engine scored in #{Time.now - start} secs"

results = {:users => engine.top_users, :tracks => engine.top_tracks}.to_json
File.open(RESULT_FILE, 'w').tap do |f|
	f.write(results)
	f.close
end



# require 'user'
# require 'api_fetch/user_syncer'
# require 'soundcloud_client'
# require 'chainable_job/base_job'

# module Smoothie
#   module ApiFetch
#     class UserFavoritesSyncer < Smoothie::ChainableJob::BaseJob

#       @queue = :api


#       def initialize(opts = {})
#         super

#         throw "id must be defined" unless @arguments['id']

#         @user = Smoothie::User.new(@arguments['id'])
#       end


#       def ready?
#         @user.favorites_up_to_date?
#       end


#       def perform
#         # Ensure the user is synced
#         wait_for ApiFetch::UserSyncer.new('id' => @user.id)

#         soundcloud = Smoothie::SoundcloudClient.new

#         # Get all the favorites ids
#         limit = @user.tracks_count.value.to_i
#         favorite_ids = soundcloud.get_user_favorites(@user.id, limit)

#         # Set them as the user favorites
#         unless favorite_ids.empty?
#           @user.track_ids.del
#           @user.track_ids.add favorite_ids
#         end

#         # Updated the synced_at time
#         @user.set_favorites_synced!
#       end

#     end
#   end
# end
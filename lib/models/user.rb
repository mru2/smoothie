# Handle persistence in neo4j
# Also querying
module Smoothie

  class User

    # Sample : 2324041

    attr_reader :id
    attr_accessor :attributes

    # Neo4j index
    if $neo.get_schema_index('User').empty?
      $neo.create_schema_index('User', ['id'])
    end

    def self.from_soundcloud(soundcloud)
      new(soundcloud.id, 
        :username   => soundcloud.username,
        :likes      => soundcloud.public_favorites_count
      )
    end

    def self.find(user_id)
      user = new(user_id)
      if user.node
        user.attributes = user.node['data'].inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
        user
      else
        nil
      end
    end

    def initialize(id, attributes = {})
      @id = id
      @attributes = attributes
      @node = nil
    end

    # Persisting
    def save
      if self.node.nil?
        node = $neo.create_node(attributes.merge(:id => id, :name => self.to_s))
        $neo.set_label(node, 'User')
        @node = node
      else
        $neo.set_node_properties self.node, attributes.merge(:name => self.to_s)
      end
    end

    # Finder
    def node
      return @node if @node

      # TODO : better query maybe?
      res = $neo.execute_query("MATCH (u:User) WHERE u.id = #{id} RETURN u")
      if res['data'].empty?
        @node = nil
      else
        @node = res['data'].first.first
      end

      @node
    end

    def add_tracks(tracks)
      tracks.each do |track|
        # Save it
        track.save

        # Add the relationship
        $neo.create_relationship('likes', node, track.node)
      end
    end

    def to_s
      s = "User ##{id}"
      s += " : #{attributes[:username]}" unless attributes.empty?
      s
    end

  end

end
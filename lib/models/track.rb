# Handle persistence in neo4j
# Also querying
module Smoothie

  class Track

    attr_reader :id
    attr_accessor :attributes

    def initialize(id, attributes = {})
      @id = id
      @attributes = attributes
    end

    # Persisting
    def create
      node = $neo.create_node(attributes.merge(:id => id, :name => self.to_s))
      $neo.add_node_to_index 'tracks', 'id', id, node
    end

    def to_s
      s = "Track ##{id}"
      s += " : #{attributes[:artist]} - #{attributes[:title]}" unless attributes.empty?
      s
    end

  end

end
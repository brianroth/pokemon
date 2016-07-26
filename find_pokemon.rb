#!/usr/bin/env ruby

require_relative "pokemon_api"
require 'geokit'

class FindPokemon

  include PokemonApi

  CURRENT_LAT=44.945676578555265
  CURRENT_LONG=-93.09581100940703
  CURRENT_LOCATION = Geokit::LatLng.new(CURRENT_LAT,CURRENT_LONG)

  def run
    messages = []
    data = get_pokemon_nearby(CURRENT_LAT, CURRENT_LONG)

    if 'success' == data['status']
      data['pokemon'].each do |pokemon|
        if pokemon['is_alive'] && 200 > distance(pokemon)
          messages << "A wild #{name(pokemon)} is nearby (#{distance(pokemon).round(0)} meters)"
        end
      end
      # puts messages.uniq.join("\n")
      post_to_slack messages.uniq.join("\n")
    else
      puts 'Request to find pokemon was not successful'
    end
  end

  def distance(pokemon)
    CURRENT_LOCATION.distance_to("#{pokemon['latitude']},#{pokemon['longitude']}", units: :meters)
  end
end

if __FILE__ == $0
  FindPokemon.new.run
end

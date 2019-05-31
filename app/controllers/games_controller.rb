
require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(10)
  end
  
  def score
    @word = params[:word]
    @letters = params[:letters_at].split(" ")
    if word_in_grid?(@word, @letters)
      if word_in_dictionary(@word)["found"]
        @result = "Congratulations, #{@word} is a valid English word!"
      else
        @result = "Sorry but #{@word} does not seem to be a valid English word..."
      end
    else
      @result = "Sorry but, #{@word} can't be built out of #{@letters = CHARS.join(', ').upcase}"
    end
  end

  def word_in_grid?(word, grid)
    grid_hash = Hash.new(0)
    grid.each { |letter| grid_hash[letter] += 1 }

    word.downcase.chars.each do |letter|
      if grid_hash[letter].positive?
        grid_hash[letter] -= 1
      else
        return false
      end
    end
    return true
  end

  def word_in_dictionary(word)
    url = 'https://wagon-dictionary.herokuapp.com/'
    # Should check API if word is on dictionary
    api_request = open(url + word).read
    word_result = JSON.parse(api_request)
    return word_result
  end

end

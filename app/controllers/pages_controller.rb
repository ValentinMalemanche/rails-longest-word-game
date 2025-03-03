require 'open-uri'

class PagesController < ApplicationController

  def new
    # afficher une nouvelle grille aléatoire et un formulaire
    @letters = []
    10.times do
      @letters << ('A'..'Z').to_a.sample
    end
  end

  def score
    @word = params[:word].upcase
    @letters = params[:letters].split
    @valid_in_grid = @word.chars.all? { |letter|
      @letters.include?(letter) && @letters.count(letter) >= @word.count(letter)
    }

    if @valid_in_grid
      response = OpenURI.open_uri("https://wagon-dictionary.herokuapp.com/#{@word}").read
      result = JSON.parse(response)
      @valid_word = result["found"]

      if @valid_word
        @score = @word.length
        session[:total_score] ||= 0
        session[:total_score] += @score
        @message = "Bravo ! #{@word} est un mot valide. Score : #{@score}"
      else
        @message = "Dommage, #{@word} n'est pas un mot valide."
      end
    else
      @message = "Erreur : #{@word} ne peut pas être formé avec les lettres proposées."
    end
  end

end

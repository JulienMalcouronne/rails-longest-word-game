require 'open-uri'
require 'json'
class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(10)
  end

  def score
    @score = {}
    if included?(params[:game], params[:letters]) == true && english_word?(params[:game]) == true
      @message = "Congratulation #{params[:game]} is a valid English word, your score is #{result(params[:game])}/10"
      total_score
    elsif included?(params[:game], params[:letters]) == false
      @message = "Sorry but #{params[:game]} can't be build out of #{params[:letters]}"
    elsif english_word?(params[:game]) == false
      @message = "Sorry but #{params[:game]} does not seem to be a valid English word..."
    end
  end

  private

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.to_s.count(letter) <= grid.to_s.count(letter) }
  end

  def result(word)
    @score[:score] = word.size
  end

  def total_score
    if session[:score].nil?
      session[:score] = @score[:score]
    else
      session[:score] += @score[:score]
    end
  end
end

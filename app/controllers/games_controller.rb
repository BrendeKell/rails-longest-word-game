require "open-uri"
class GamesController < ApplicationController

  def new
    @random_letters = Array.new(10) { ('a'..'z').to_a.sample }
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    @included = included?(@word, @letters)
    @valid_word = valid_word?(@word)

    if @included && @valid_word
      @score = @word.length
      @message = "Congratulations! #{@word} is a valid English word."
    elsif @included
      @score = 0
      @message = "Sorry, but #{@word} does not seem to be a valid English word."
    else
      @score = 0
      @message = "Sorry, but #{@word} can't be built out of #{@letters.split.join(', ')}."
    end
  end

  private

  def included?(word, letters)
    word.chars.all? do |letter|
      word.count(letter) <= letters.count(letter)
    end
  end

  def valid_word?(word)
    url = "https://dictionary.lewagon.com/#{word}"
    response = URI.open(url).read
    json = JSON.parse(response)
    json['found']
  end
end

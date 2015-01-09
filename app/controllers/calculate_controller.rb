class CalculateController < ApplicationController

  def index
  end

  def guiltfree_days
    d = params[:days].to_i
    p = params[:probability].to_f

    @result = calc_guiltfree_days d, p
  end

  def checked_boxes
    # het aantal opengekraste vakjes, gegeven type lot en aantal opengekraste vakjes met gelijke categorieeen
    x = params[:number].to_i #x
    sigma = params[:ticket].to_i # sigma
    v = params[:identical].to_i #v

    @result = calc_checked_boxes v, x, sigma
  end

private

  def bin_co n, r
    (0...r).inject(1) do |m,i| (m * (n - i)) / (i + 1) end
  end

  def calc_guiltfree_days d, p
    bin_co(6, d) * p**d * (1-p)**(6-d)
  end

  def calc_checked_boxes v, x, sigma
    ( bin_co(sigma, v) * bin_co((6.to_f - sigma), (x-v)) ) / bin_co(6.to_f, x)
  end
end

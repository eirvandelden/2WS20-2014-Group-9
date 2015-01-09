class CalculateController < ApplicationController

  def index
  end

  def guiltfree_days
    d = params[:days].to_i
    p = params[:probability].to_f

    @result = bin_co(6, d) * p**d * (1-p)**(6-d)
  end

private

  def bin_co n, r
    (0...r).inject(1) do |m,i| (m * (n - i)) / (i + 1) end
  end

end

class CalculateController < ApplicationController

def index
end

def days
  d = params[:days].to_i
  @result = d
end

end

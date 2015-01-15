class CalculateController < ApplicationController
  PRIZE_MONEY = { 6 => 0, 5 => 50, 4 => 25, 3 => 10 }
  LOSER_MONEY = { 1 => 2.5, 2 => 5.0, 3 => 7.5 }

  def index
  end

  def complaintfree_days
    d = params[:days].to_i
    p = params[:probability].to_f

    @result = calc_complaintfree_days d, p
  end

  def checked_boxes
    # het aantal opengekraste vakjes, gegeven type lot en aantal opengekraste vakjes met gelijke categorieeen
    x = params[:number].to_i #x
    sigma = params[:ticket].to_i # sigma
    v = params[:identical].to_i #v

    @result = calc_checked_boxes v, x, sigma
  end

  def prize_value
    v = params[:type].to_i

    @result = calc_prize_money v
  end

  def expected_value_ticket
    p = params[:probability].to_f
    sigma = params[:type].to_i

    @result = calc_expected_value_ticket p, sigma
  end

  def weekly_value
    six = params[:six].to_i
    five = params[:five].to_i
    four = params[:four].to_i
    three = params[:three].to_i
    a = params[:a].to_i
    b = params[:b].to_i
    c = params[:c].to_i

    p = params[:probability].to_f

    @result = calc_weekly_value six, five, four, three, p, a, b, c
  end

  def variance_value_lottery
    sigma = params[:type].to_i
    p = params[:probability].to_f

    @result = calc_variance_value_lottery p, sigma
  end

  def variance_value_loser
    v = params[:type].to_i
    p = params[:probability].to_f

    @result = calc_variance_value_loser p, v
  end

  def weekly_variance
    six = params[:six].to_i
    five = params[:five].to_i
    four = params[:four].to_i
    three = params[:three].to_i
    a = params[:a].to_i
    b = params[:b].to_i
    c = params[:c].to_i

    p = params[:probability].to_f

    @result = calc_weekly_variance six, five, four, three, p, a, b, c
  end

private

  def bin_co n, r
    (0...r).inject(1) do |m,i| (m * (n - i)) / (i + 1) end
  end

  def calc_complaintfree_days d, p
    bin_co(6, d) * p**d * (1-p)**(6-d)
  end

  def calc_checked_boxes v, x, sigma
    ( bin_co(sigma, v) * bin_co((6.to_f - sigma), (x-v)) ) / bin_co(6.to_f, x)
  end

  def calc_prize_money v
    PRIZE_MONEY[v] || 0
  end

  def calc_loser_money v
    LOSER_MONEY[v] || 0
  end

  def calc_expected_value_ticket p, sigma, squared = false
    result_v = 0
    result_x = 0

    for x in 0..6 do
      for v in 0..sigma do
        if squared
          result_v += (calc_prize_money(v) ** 2 ) * calc_checked_boxes(v, x, sigma)
        else
          result_v += calc_prize_money(v) * calc_checked_boxes(v, x, sigma)
        end
      end
      result_x += result_v * calc_complaintfree_days(x, p)
      result_v = 0
    end

    result_x
  end

  def calc_weekly_value six, five, four, three, p, a, b, c
    (six * calc_expected_value_ticket(p, 6)) +
    (five  * calc_expected_value_ticket(p, 5)) +
    (four  * calc_expected_value_ticket(p, 4)) +
    (three * calc_expected_value_ticket(p, 3)) +
    (a * 2.5 * calc_complaintfree_days(6, p)) +
    (b * 5.0 * calc_complaintfree_days(6, p)) +
    (c * 7.5 * calc_complaintfree_days(6, p))
  end

  def calc_variance_value_lottery p, sigma
    calc_expected_value_ticket(p, sigma, true) - (calc_expected_value_ticket(p, sigma) ** 2)
  end

  def calc_variance_value_loser p, v
     ((calc_loser_money(v) ** 2) * calc_complaintfree_days(6, p)) - ((calc_loser_money(v) * calc_complaintfree_days(6, p)) ** 2)
  end

  def calc_weekly_variance six, five, four, three, p, a, b, c
    ((six ** 2) * calc_variance_value_lottery(p, 6)) +
    ((five ** 2) * calc_variance_value_lottery(p, 5)) +
    ((four ** 2) * calc_variance_value_lottery(p, 4)) +
    ((three ** 2) * calc_variance_value_lottery(p, 3)) +
    ((a ** 2) * calc_variance_value_loser(p, 1)) +
    ((b ** 2) * calc_variance_value_loser(p, 2)) +
    ((c ** 2) * calc_variance_value_loser(p, 3))
  end
end

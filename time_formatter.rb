require 'time'

class TimeFormatter
  VALUES = {
    year:   '%Y',
    month:  '%m',
    day:    '%d',
    hour:   '%H',
    minute: '%M',
    second: '%S'
  }.freeze

  def initialize(csv)
    @csv   = csv
    @right = []
    @wrong = []
  end

  def call
    values = @csv.split(',').map(&:to_sym)

    values.each do |value|
      if VALUES[value]
        @right << VALUES[value]
      else
        @wrong << value
      end
    end
  end

  def right?
    @wrong.empty?
  end

  def format
    str = @right.join('-')
    Time.now.strftime(str)
  end

  def wrong
    @wrong.join(', ')
  end
end

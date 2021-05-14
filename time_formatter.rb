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
    values = csv.split(',').map(&:to_sym)

    @right = get_right(values)
    @wrong = get_wrong(values)
  end

  def right?
    @wrong.empty?
  end

  def to_s
    right? ? Time.now.strftime(@right) : @wrong
  end

  private

  def get_right(values)
    (values & VALUES.keys).each_with_object([]) do |key, arr|
      arr << VALUES[key]
    end.join('-')
  end

  def get_wrong(values)
    (values - VALUES.keys).join(', ')
  end
end

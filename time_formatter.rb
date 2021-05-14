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
    @values = csv.split(',').map(&:to_sym)
    @wrong  = @values - VALUES.keys
  end

  def valid?
    @wrong.empty?
  end

  def format
    fstr = ''

    VALUES.each { |key, val| fstr << "#{val}-" if @values.include?(key) }

    time = Time.now.strftime(fstr[0..-2])

    "Time: #{time}\n"
  end

  def wrong_format
    values = @wrong.join(', ')

    "Wrong time format: [#{values}]\n"
  end
end

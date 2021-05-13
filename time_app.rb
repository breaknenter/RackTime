require 'time'

class TimeApp
  STATUS = {
    ok:          200,
    bad_request: 400,
    not_found:   404
  }.freeze

  HEADERS = {
    'Content-Type' => 'text/plain'
  }.freeze

  FORMATS = %w[year month day hour minute second].freeze

  VALUES = {
    'year'   => -> { "Year:   #{Date.today.year}\n"         },
    'month'  => -> { "Month:  #{Date.today.month}\n"        },
    'day'    => -> { "Day:    #{Date.today.day}\n"          },
    'hour'   => -> { "Hour:   #{Time.now.hour}\n"           },
    'minute' => -> { "Minute: #{Time.now.strftime('%M')}\n" },
    'second' => -> { "Second: #{Time.now.strftime('%S')}\n" }
  }.freeze

  def call(env)
    req = Rack::Request.new(env)

    if req.get?
      case req.path_info
      when '/time'   then parse_n_put(req.params)
      when '/wakeup' then wake_up
      else not_found
      end
    end
  end

  private

  def prompt
    msg = <<~INFO
      Time format: /time?format=year%2Cmonth%2Cday
      Time values: [year month day hour minute second]
    INFO

    [
      STATUS[:ok],
      HEADERS,
      [msg]
    ] 
  end

  def parse_n_put(params)
    if params.empty?
      prompt
    else
      params  = params['format'].split(',')
      unknown = []

      params.each { |param| unknown << param unless FORMATS.include?(param) }

      unknown.any? ? unknown_format(unknown) : show_time(params)
    end
  end

  def show_time(params)
    time = "Time:\n"

    VALUES.each { |key, val| time += val.call if params.include?(key) }

    [
      STATUS[:ok],
      HEADERS,
      [time]
    ]
  end

  def wake_up
    art = <<-'ART'

                   ♪ https://youtu.be/WD_MTAxdYP0
            _____|~~\_____      _____________
        _-~               \    |    \
        _-    | )     \    |__/   \   \
        _-         )   |   |  |     \  \
        _-    | )     /    |--|      |  |
       __-_______________ /__/_______|  |_________
      (                |----         |  |
       `---------------'--\\\\      .`--'
                                    `||||

    ART

    [
      STATUS[:ok],
      HEADERS,
      [art]
    ]
  end

  def unknown_format(params)
    params = params.join(', ')

    [
      STATUS[:bad_request],
      HEADERS,
      ["Unknown time format: [#{params}]\n"]
    ]
  end

  def not_found
    [
      STATUS[:not_found],
      HEADERS,
      ["Route not found\n"]
    ]
  end
end

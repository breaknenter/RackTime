require_relative 'time_formatter'

class TimeApp
  def call(env)
    request = Rack::Request.new(env)

    if request.get?
      path   = request.path_info
      params = request.params['format']

      router(path, params)
    end
  end

  private

  def router(path, params)
    if params
      case path
      when '/time'   then time(params)
      when '/wakeup' then response(wake_up)
      else response(not_found, 404)
      end
    else
      response(prompt)
    end
  end

  def response(body, status = 200 , headers = { 'Content-Type' => 'text/plain' })
    Rack::Response.new(body, status, headers).finish
  end

  def time(csv)
    time = TimeFormatter.new(csv)

    if time.right?
      response("Time: #{time}")
    else
      response("Wrong time format: [#{time.wrong}]", 400)
    end
  end

  def prompt
    <<~MSG
      Time format: /time?format=year%2Cmonth%2Cday
      Time values: [year month day hour minute second]
    MSG
  end

  def wake_up
    <<-'ART'

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
  end

  def not_found
    "Route not found\n"
  end
end

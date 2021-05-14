require_relative 'time_formatter'

class TimeApp
  def call(env)
    request = Rack::Request.new(env)

    if request.get?
      params = request.params['format']
      path   = request.path_info

      case path
      when '/time'
        unless params.nil?
          time = TimeFormatter.new(params)

          time.valid? ? response(time.format) :
                        response(time.wrong_format, 400)
        else
          response(prompt)
        end
      when '/wakeup'
        response(wake_up)
      else
        response(not_found, 404)
      end
    end
  end

  private

  def response(body, status = 200 , headers = { 'Content-Type' => 'text/plain' })
    Rack::Response.new(body, status, headers).finish
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

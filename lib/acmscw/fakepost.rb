module AcmScW
  class Fakepost

    def call(env)
      request  = ::Rack::Request.new(env)
      location = request.params['__referer__'] || '/'
      [301, {"Location" => location}, []]
    end

  end # class Fakepost
end # module AcmScW

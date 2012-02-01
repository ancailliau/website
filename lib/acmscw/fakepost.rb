module AcmScW
  class Fakepost

    def call(env)
      [301, {"Location" => "/"}, []]
    end

  end # class Fakepost
end # module AcmScW

module TelegramBot
  class Location
    include Virtus.model
    attribute :latitude, Float
    attribute :longitude, Float

    def full
      [latitude, longitude]
    end
  end
end

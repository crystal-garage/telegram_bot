module TelegramBot
  class MaskPosition
    include JSON::Serializable

    property point : String
    property x_shift : Float64
    property y_shift : Float64
    property scale : Float64

    def initialize(
      @point : String,
      @x_shift : Float64,
      @y_shift : Float64,
      @scale : Float64,
    )
    end
  end
end

module Mu
  class Message < Object
    @terminator : Bool

    def initialize(name : String)
      @name = name
      @args = [] of Mu::Value

      @cached_value = false

      @terminator = (@name == ";" || @name == "\n")

      super()
    end

    def call(receiver : Object, context = receiver)
      if @terminator
        value = context
      else
        slot = receiver.getSlot(@name)
        if slot.nil?
          error = Object.new(nil, nil, "Error")
          error.setSlot("message", Object.new(nil, "Cannot find slot `#{@name}` for `#{receiver.type}`."))
          return error
        else
          value = slot.call(receiver, context)
        end
      end
      value
    end

    def to_s
      if @terminator
        "<Message terminator>"
      else
        "<Message @name=#{@name}>"
      end
    end
  end
end

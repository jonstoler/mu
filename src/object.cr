module Mu
  alias Primitive = (Nil | Bool | Float64 | String)
  alias Value = (Proc(Nil) | Mu::Object | Mu::Primitive | Array(Mu::Value) | Hash(String, Mu::Value) | Proc(Mu::Value, Mu::Value) | Proc(Mu::Value))

  class Object
    @protos : Array(Mu::Object)

    getter type, value

    def initialize(proto : (Mu::Object | Nil) = nil, value : Mu::Value = nil, type : String = "Object")
      if proto.nil?
        @protos = [] of Mu::Object
      else
        @protos = [proto]
      end
      @value = value
      @slots = Hash(String, Mu::Object).new
      @type = type
    end

    def getSlot(name : String)
      return @slots[name] if @slots.fetch(name, false)
      message = nil
      @protos.each { |proto| return message if message = proto.getSlot(name) }
    end

    def setSlot(name : String, val : (Mu::Object))
      @slots[name] = val
    end

    def call(*args)
      if (value = @value).is_a?(Proc(Nil))
        value.call
      else
        return self
      end
    end

    def clone(val : Mu::Value = nil)
      val ||= @value && @value.dup
      Object.new(self, val)
    end

    def to_s
      "<#{@type}>"
    end
  end
end

module Mu
  # values that can be cached by an object
  alias Val = (Nil | Bool | Float64 | String)

  # values that can be passed around the VM
  alias Type = (Mu::Val | Proc(Message, Method) | Proc(Nil) | Mu::Object | Array(Mu::Object) | Hash(String, Mu::Object))

  class Object
    @protos : Array(Mu::Object)

    getter type, value

    def initialize(proto : (Mu::Object | Nil) = nil, value : Mu::Type = nil, type : String = "Object")
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

    def clone(val : Mu::Type = nil)
      val ||= @value && @value.dup
      Object.new(self, val)
    end

    def to_s
      "<#{@type}>"
    end
  end
end

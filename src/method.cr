module Mu
  class Method < Object
    @message : Mu::Message

    def initialize(message)
      @message = message
      super()
    end

    def call(receiver : Object, caller = receiver)
      context = caller.clone
      context.setSlot("self", receiver)
      @message.call(context)
    end
  end
end

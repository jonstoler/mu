require "./parser.cr"
require "./object.cr"
require "./message.cr"

module Mu
  class VM
    @tokens : Array(Token)

    def initialize
      @tokens = [] of Token
      @runtime = Object.new(nil, nil, "Lobby")
      @runtime.setSlot("Object", Object.new)
    end

    def exec(code)
      parser = Parser.new(code)
      @tokens = parser.parse

      context = @runtime

      object = context.getSlot("Object").as(Object)
      object.setSlot("sayHello", Object.new(nil, ->{ puts "hello from Mu!" }))

      @tokens.each do |token|
        if token[:kind] == TokenType::NumberLiteral
        else
          message = Message.new(token[:value])
          context = message.call(context, @runtime)
          if !context.nil? && context.type == "Error"
            message = context.getSlot("message")
            (puts "[ERROR] " + message.value.as(String)) if !message.nil?
            break
          end
        end
      end
    end
  end
end

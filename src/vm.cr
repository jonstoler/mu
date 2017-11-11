require "./parser.cr"
require "./object.cr"
require "./message.cr"
require "./method.cr"

module Mu
  class VM
    @tokens : Array(Token)

    def initialize
      @tokens = [] of Token
      @lobby = Object.new(nil, nil, "Lobby")
    end

    def bootstrap
      object = Object.new
      object.setSlot("sayHello", newMethod ->{ puts "hello from Mu!" })

      @lobby.setSlot("Object", object)
      @lobby.setSlot("method", newMethod ->{ puts "create method" })
    end

    def newMethod(method : Proc(Nil))
      Object.new(nil, method, "Method")
    end

    def exec(code)
      parser = Parser.new(code)
      @tokens = parser.parse

      context = @lobby

      index = 0
      peek = ->{
        if (index + 1) < @tokens.size
          return @tokens[index + 1]
        else
          return Token.new(kind: TokenType::EOF, value: "\0")
        end
      }
      consume = ->{
        t = peek.call
        index += 1
        return t
      }

      while index < @tokens.size
        token = consume.call
        if token[:kind] == TokenType::EOF
          break
        elsif peek.call[:kind] == TokenType::ParenLeft
          consume.call
          body = [] of Token
          while peek.call[:kind] != TokenType::ParenRight && peek.call[:kind] != TokenType::EOF
            body << consume.call
          end
          consume.call
        else
          message = Message.new(token[:value])
          context = message.call(context, @lobby)
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

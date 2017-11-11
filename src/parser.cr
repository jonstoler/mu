module Mu
  enum TokenType
    Identifier
    ParenLeft
    ParenRight
    Comma
    NumberLiteral
    StringLiteral
    HashComment
    LineComment
    EOL
    EOF
  end

  alias Token = NamedTuple(kind: TokenType, value: String)

  class Parser
    def initialize(code : String)
      @code = code
      @tokens = [] of Token
      @cursor = 0
    end

    def parse
      firstLine = true
      while @cursor < @code.chars.size
        char = peek
        if firstLine && char == '#'
          while (peek != '\n' && peek != '\0')
            @cursor += 1
          end
        elsif isNumberLiteral
          number = ""
          while isNumberLiteral
            number += peek
            @cursor += 1
          end
          @tokens << Token.new(kind: TokenType::NumberLiteral, value: number)
        elsif (char == '/' && peek == '/')
          while (peek != '\n' && peek != '\0')
            @cursor += 1
          end
        elsif (char == ' ' || char == '\t')
          @cursor += 1
        elsif char == '\n'
          firstLine = false
          @cursor += 1
          @tokens << Token.new(kind: TokenType::EOL, value: "\n")
        elsif char == '('
          @cursor += 1
          @tokens << Token.new(kind: TokenType::ParenLeft, value: "(")
        elsif char == ')'
          @cursor += 1
          @tokens << Token.new(kind: TokenType::ParenRight, value: ")")
        elsif char == ','
          @cursor += 1
          @tokens << Token.new(kind: TokenType::Comma, value: ",")
        elsif isIdentifier
          identifier = ""
          while isIdentifier
            identifier += peek
            @cursor += 1
          end
          @tokens << Token.new(kind: TokenType::Identifier, value: identifier)
        elsif char == '\0'
          break
        else
          puts "[ERROR] Unexpected character: #{char}"
          break
        end
      end
      @tokens
    end

    private def peek
      if @cursor < @code.chars.size
        return @code.char_at(@cursor)
      else
        return '\0'
      end
    end

    private def isNumberLiteral
      char = peek
      return char >= '0' && char <= '9'
    end

    private def isIdentifier
      char = peek
      return (char >= 'a' && char <= 'z') || (char >= 'A' && char <= 'Z') || char == '_'
    end
  end
end

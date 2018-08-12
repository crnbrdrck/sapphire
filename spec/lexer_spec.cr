require "./spec_helper"

# Unlike how the interpreter book works, we're going to be using files from the start
# These files are going to be stored in `<project>/examples/*.sph`
describe Sapphire::Lexer do
  it "correctly creates Token instances for all single character tokens in Sapphire" do
    # Lexer also handles strings. This is for REPL and such. This might change later.
    input = "=+(){},:"
    file_name = "<stdin>"

    # Generate an array of tokens that are expected to be generated by the Lexer
    expected_tokens = [
      Sapphire::Token.new(Sapphire::TokenType::ASSIGN, "=", file_name, 1, 1),
      Sapphire::Token.new(Sapphire::TokenType::PLUS, "+", file_name, 1, 2),
      Sapphire::Token.new(Sapphire::TokenType::LEFT_PAREN, "(", file_name, 1, 3),
      Sapphire::Token.new(Sapphire::TokenType::RIGHT_PAREN, ")", file_name, 1, 4),
      Sapphire::Token.new(Sapphire::TokenType::LEFT_BRACE, "{", file_name, 1, 5),
      Sapphire::Token.new(Sapphire::TokenType::RIGHT_BRACE, "}", file_name, 1, 6),
      Sapphire::Token.new(Sapphire::TokenType::COMMA, ",", file_name, 1, 7),
      Sapphire::Token.new(Sapphire::TokenType::COLON, ":", file_name, 1, 8),
      Sapphire::Token.new(Sapphire::TokenType::EOF, Char::ZERO.to_s, file_name, 2, 1),
    ]

    # Create a lexer for this file
    lexer = Sapphire::Lexer.new input

    # Loop through the expected_tokens array and ensure that the tokens match the lexer output
    expected_tokens.each do |expected|
      received = lexer.get_next_token
      received.token_type.should eq expected.token_type
      received.literal.should eq expected.literal
      received.file_name.should eq expected.file_name
      received.line_num.should eq expected.line_num
      received.char_num.should eq expected.char_num
    end
  end

  it "correctly creates Token instances given the `example1.sph` script as input" do
    file_name = "examples/example1.sph"
    input_file = File.open file_name

    # Generate an array of expected Tokens
    expected_tokens = [
      # let five: int = 5
      Sapphire::Token.new(Sapphire::TokenType::LET, "let", file_name, 1, 1),
      Sapphire::Token.new(Sapphire::TokenType::IDENTIFIER, "five", file_name, 1, 5),
      Sapphire::Token.new(Sapphire::TokenType::COLON, ":", file_name, 1, 9),
      Sapphire::Token.new(Sapphire::TokenType::IDENTIFIER, "int", file_name, 1, 11),
      Sapphire::Token.new(Sapphire::TokenType::ASSIGN, "=", file_name, 1, 15),
      Sapphire::Token.new(Sapphire::TokenType::INTEGER, "5", file_name, 1, 17),

      # let ten: int = 10
      Sapphire::Token.new(Sapphire::TokenType::LET, "let", file_name, 2, 1),
      Sapphire::Token.new(Sapphire::TokenType::IDENTIFIER, "ten", file_name, 2, 5),
      Sapphire::Token.new(Sapphire::TokenType::COLON, ":", file_name, 2, 8),
      Sapphire::Token.new(Sapphire::TokenType::IDENTIFIER, "int", file_name, 2, 10),
      Sapphire::Token.new(Sapphire::TokenType::ASSIGN, "=", file_name, 2, 14),
      Sapphire::Token.new(Sapphire::TokenType::INTEGER, "10", file_name, 2, 16),

      # def add(x: num, y: num) -> num {
      Sapphire::Token.new(Sapphire::TokenType::FUNCTION, "def", file_name, 4, 1),
      Sapphire::Token.new(Sapphire::TokenType::IDENTIFIER, "add", file_name, 4, 5),
      Sapphire::Token.new(Sapphire::TokenType::LEFT_PAREN, "(", file_name, 4, 8),
      Sapphire::Token.new(Sapphire::TokenType::IDENTIFIER, "x", file_name, 4, 9),
      Sapphire::Token.new(Sapphire::TokenType::COLON, ":", file_name, 4, 10),
      Sapphire::Token.new(Sapphire::TokenType::IDENTIFIER, "num", file_name, 4, 12),
      Sapphire::Token.new(Sapphire::TokenType::COMMA, ",", file_name, 4, 15),
      Sapphire::Token.new(Sapphire::TokenType::IDENTIFIER, "y", file_name, 4, 17),
      Sapphire::Token.new(Sapphire::TokenType::COLON, ":", file_name, 4, 18),
      Sapphire::Token.new(Sapphire::TokenType::IDENTIFIER, "num", file_name, 4, 20),
      Sapphire::Token.new(Sapphire::TokenType::RIGHT_PAREN, ")", file_name, 4, 23),
      Sapphire::Token.new(Sapphire::TokenType::RETURN_TYPE, "->", file_name, 4, 25),
      Sapphire::Token.new(Sapphire::TokenType::IDENTIFIER, "num", file_name, 4, 28),
      Sapphire::Token.new(Sapphire::TokenType::LEFT_BRACE, "{", file_name, 4, 32),

      # return x + y
      Sapphire::Token.new(Sapphire::TokenType::RETURN, "return", file_name, 5, 5),
      Sapphire::Token.new(Sapphire::TokenType::IDENTIFIER, "x", file_name, 5, 12),
      Sapphire::Token.new(Sapphire::TokenType::PLUS, "+", file_name, 5, 14),
      Sapphire::Token.new(Sapphire::TokenType::IDENTIFIER, "y", file_name, 5, 16),

      # }
      Sapphire::Token.new(Sapphire::TokenType::RIGHT_BRACE, "}", file_name, 6, 1),

      # let result: num = add(five, ten)
      Sapphire::Token.new(Sapphire::TokenType::LET, "let", file_name, 8, 1),
      Sapphire::Token.new(Sapphire::TokenType::IDENTIFIER, "result", file_name, 8, 5),
      Sapphire::Token.new(Sapphire::TokenType::COLON, ":", file_name, 8, 11),
      Sapphire::Token.new(Sapphire::TokenType::IDENTIFIER, "num", file_name, 8, 13),
      Sapphire::Token.new(Sapphire::TokenType::ASSIGN, "=", file_name, 8, 17),
      Sapphire::Token.new(Sapphire::TokenType::IDENTIFIER, "add", file_name, 8, 19),
      Sapphire::Token.new(Sapphire::TokenType::LEFT_PAREN, "(", file_name, 8, 22),
      Sapphire::Token.new(Sapphire::TokenType::IDENTIFIER, "five", file_name, 8, 23),
      Sapphire::Token.new(Sapphire::TokenType::COMMA, ",", file_name, 8, 27),
      Sapphire::Token.new(Sapphire::TokenType::IDENTIFIER, "ten", file_name, 8, 29),
      Sapphire::Token.new(Sapphire::TokenType::RIGHT_PAREN, ")", file_name, 8, 32),

      # EOF
      Sapphire::Token.new(Sapphire::TokenType::EOF, Char::ZERO.to_s, file_name, 9, 1),
    ]

    # Create a lexer for this file
    lexer = Sapphire::Lexer.new input_file
    # Loop through the expected_tokens array and ensure that the tokens match the lexer output
    expected_tokens.each do |expected|
      received = lexer.get_next_token
      received.token_type.should eq expected.token_type
      received.literal.should eq expected.literal
      received.file_name.should eq expected.file_name
      received.line_num.should eq expected.line_num
      received.char_num.should eq expected.char_num
    end
  end
end

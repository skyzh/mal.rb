require 'readline'
require_relative 'reader'
require_relative 'printer'

def READ(x)
  read_str(x)
end

def EVAL(x, env)
  case x
  when Array then
    if x.empty?
      x
    else
      eval_result = eval_ast(x, env)
      eval_result[0][*eval_result.drop(1)]
    end
  else
    eval_ast(x, env)
  end
end

def PRINT(x)
  puts(pr_str(x))
end

def rep(x)
  env = default_environment
  PRINT(EVAL(READ(x), env))
end

def default_environment
  {
      :+ => lambda { |a, b| a + b },
      :- => lambda { |a, b| a - b },
      :* => lambda { |a, b| a * b },
      :/ => lambda { |a, b| a / b }
  }
end

def eval_ast(ast, env)
  case ast
  when Symbol
    unless env.key?(ast)
      raise "symbol not found"
    end
    env[ast]
  when Array
    ast.map { |x| EVAL(x, env) }
  else
    ast
  end
end

while (buf = Readline.readline("user> ", true))
  begin
    rep(buf)
  rescue Exception => e
    puts "Error: #{e}"
    puts "\t#{e.backtrace.join("\n\t")}"
  end
end

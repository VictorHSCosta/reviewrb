require "thor"

module Reviewrb
  class CLI < Thor
    desc "ask", "Start the ReviewRB CLI"
    def ask
      puts "Welcome to ReviewRB!"
    end
  end
end
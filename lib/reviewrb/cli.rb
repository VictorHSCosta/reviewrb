require 'thor'
require 'tty-prompt'
require 'reviewrb/commands/init'

module Reviewrb
  class CLI < Thor
    desc 'init', 'Start the ReviewRB CLI'
    def init
      Reviewrb::Commands::Init.call
    end
  end
end

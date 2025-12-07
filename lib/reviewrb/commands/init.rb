require 'reviewrb/git/start'
require 'pastel'

module Reviewrb
  module Commands
    class Init
      def self.call
        current_branch = Reviewrb::Git::Start.call
        prompt = TTY::Prompt.new
        puts "Current Git Branches:\n#{current_branch}"
        choices = %w[yes no]
        is_correct_branch = prompt.select('Is this your current branch that you want to use for the review?', choices)

        if is_correct_branch == 'yes'
          puts 'Great! Proceeding with the review on branch.'
        else
          branches = Reviewrb::Git::Start.list_branches
          branch_choice = prompt.select('Select the branch you want to use for the review:', branches.split("\n"))
          puts "You have selected branch: #{branch_choice}. Proceeding with the review."
        end

        Reviewrb::Git::Start.prit_diff
      end
    end
  end
end

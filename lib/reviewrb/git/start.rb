require 'open3'

module Reviewrb
  module Git
    class Start
      @pastel = Pastel.new

      def self.call
        puts 'Starting ReviewRB Git integration...'
        stdout_s, = Open3.capture2('git branch')
        stdout_s
      end

      def self.list_branches
        stdout_s, = Open3.capture2('git branch -a')
        stdout_s
      end

      def change_branch(_new_branch)
        stdout_s, = Open3.capture2('git branch -a')
        stdout_s
      end

      def self.current_branch
        current_branch = call
        current_branch = current_branch.strip.split("\n")
        current_branch = current_branch.find { |branch| branch.strip.start_with?('*') }
        current_branch ? current_branch.gsub('*', '').strip : nil
      end

      def self.name_of_branch_main
        all_branches = list_branches
        main_branch = all_branches.lines.find { |line| line.include?('main') || line.include?('master') }
        main_branch ? main_branch.strip.gsub('* ', '') : nil
      end

      def self.diff
        main = name_of_branch_main

        return false unless main

        stdout_s, = Open3.capture2("git diff #{current_branch} #{name_of_branch_main}")

        stdout_s
      end

      def self.prit_diff
        branch_diff = diff.split("\n")

        branch_diff.each do |line|
          if line.start_with?('+')
            puts @pastel.white.on_green.bold(line)
          elsif line.start_with?('-')
            puts @pastel.white.on_red.bold(line)
          else
            puts line
          end
        end
      end
    end
  end
end

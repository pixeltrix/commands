require 'rails/console/test_environment'

module Rails
  module ConsoleMethods
    class Tester
      def test(what = nil)
        case what
        when NilClass
          print_test_usage
        when "all"
          run "test/**/**/*_test.rb"
        when /^[^\/]+$/ # models
          run "test/#{what}/**/*_test.rb"
        when /[\/]+/ # models/person
          run "test/#{what}_test.rb"
        end

        "Completed"
      end

      private
        def run(*test_patterns)
          TestEnvironment.fork do
            test_patterns.each do |test_pattern|
              Dir[test_pattern].each do |path|
                require File.expand_path(path)
              end
            end
          end
        end

        def print_test_usage
          puts <<-EOT
    Usage:
      test "WHAT"

    Description:
        Runs either a full set of test suites or single suite.

        If you supply WHAT with either models, controllers, helpers, integration, or performance,
        those whole sets will be run.

        If you supply WHAT with models/person, just test/models/person_test.rb will be run.
    EOT
        end
    end

    def tester
      @tester ||= Tester.new
    end

    def test(what = nil)
      tester.test(what)
    end
  end
end

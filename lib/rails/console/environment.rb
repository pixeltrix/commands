module Rails
  module ConsoleMethods
    module Environment
      extend self

      def fork
        Kernel.fork do
          yield
          Kernel.exit
        end

        Process.waitall
      end
    end
  end
end

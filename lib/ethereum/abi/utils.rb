module Ethereum
  module HandyMethods
    #     uint    #
    def uint(val)
      Argument.new Type.pick('uint256'), val
    end

    8.step(by: 8, to: 256).each do |size|
      module_eval %Q{
        def uint#{size}(val)
          Argument.new Type.pick('uint#{size}'), val
        end
      }
    end

    #     int    #
    def int(val)
      Argument.new Type.pick('int256'), val
    end

    8.step(by: 8, to: 256).each do |size|
      module_eval %Q{
        def int#{size}(val)
          Argument.new Type.pick('int#{size}'), val
        end
      }
    end

    #     string    #
    def string(val)
      Argument.new Type.pick("string#{val.length}"), val
    end

    1.step(to: 32).each do |size|
      module_eval %Q{
        def string#{size}(val)
          Argument.new Type.pick('string#{size}'), val
        end
      }
    end

    #     bool    #
    def bool(val)
      Argument.new Type.pick('bool'), val
    end

    #     address    #
    def address(val)
      Argument.new Type.pick('address'), val
    end
  end
end

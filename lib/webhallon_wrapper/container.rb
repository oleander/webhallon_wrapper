module WebhallonWrapperModule
  class Container
    def initialize(args)
       args.keys.each { |name| instance_variable_set "@" + name.to_s, args[name] }
    end
  end
end
class Inbound::RouteMap

  DEFAULT_CLASS = Inbound::Error::ClassDefault

  attr_reader :context

  # ----- config macro -----

  # Inbound::RouteMap.config do
  #   use(Klas1).when { |inbound| inbound.present? }
  #   use(Klas2).when { |inbound| inbound.absent?  }
  # end

  # usage: `Inbound::RouteMap.handler_for(inbound)`

  def self.config(&outer_block)
    define_method('setup_context') do
      @context = []
      instance_eval &outer_block
    end
  end

  def self.handler_for(inbound)
    instance = allocate
    raise 'Missing Config' unless instance.respond_to?(:setup_context)
    instance.setup_context
    instance.send(:handler_for, inbound)
  end

  def self.default_class
    DEFAULT_CLASS
  end

  # ----- instance methods -----

  def default_class
    @default_class || self.class.default_class
  end

  def set_default_class(klas)
    @default_class = klas
  end

  def set_base_module(module_obj)
    @module = module_obj
  end

  def clear_base_module
    @module = nil
  end

  def use(klas = nil)
    @tmp_klas = @module.present? ? "#{@module}::#{klas}".constantize : klas
    self
  end

  def when(&block)
    @context << [@tmp_klas, block]
  end
  alias_method :if, :when

  def unless(&block)
    @context << [@tmp_klas, ->(inb){! block.call(inb)}]
  end

  def rules_for(_label)
    yield if block_given?
  end

  def handler_for(inbound)
    obj = inbound.extend(Inbound::ForRouting)
    klas = @context.find {|rule| rule.last.call(obj) }.try(:first)
    dev_log "HANDLER CLASS > #{klas}"
    dev_log "INBOUND ID    > #{inbound.id}"
    klas || default_class
  end
end
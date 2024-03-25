class LogReaderMock
  attr_writer :matches_grouped_events

  def initialize
    @subscriptions = {}
  end

  def subscribe_on(event_name, &block)
    @subscriptions[event_name] = block
  end

  def call(_)
    @matches_grouped_events.each do |grouped_events|
      @subscriptions[:match_start].call
      @subscriptions.except(:match_start).each do |event_name, block|
        grouped_events[event_name].each { |params| block.call(*params) }
      end
    end
  end
end

class LogFileReaderAdapter
  AVAILABLE_EVENTS = %i[match_start player_join player_update kill].freeze

  def initialize
    @event_handlers = AVAILABLE_EVENTS.to_h { |event| [event, proc {}] }
  end

  def sign_event(event, &block)
    @event_handlers[event] = block
  end

  def call(file_path)
    File.open(file_path, 'r').each_line do |line|
      case line
      when /^  0:00 InitGame/ then call_event(:match_start)
      when /ClientConnect: (\d)/
        call_event(:player_join, Regexp.last_match(1).to_i)
      when /ClientUserinfoChanged: (\d) n\\([\w+|\s]*)/
        call_event(:player_update, Regexp.last_match(1).to_i, Regexp.last_match(2))
      when /Kill: (\d+) (\d+) \d+: <?[\w+|\s]*>? killed [\w+|\s]* by (\w+)/
        call_event(:kill, Regexp.last_match(1).to_i, Regexp.last_match(2).to_i, Regexp.last_match(3))
      end
    end
  end

  private

  def call_event(event, *params)
    @event_handlers[event].call(*params)
  end
end

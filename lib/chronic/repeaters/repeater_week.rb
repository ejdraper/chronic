module Chronic
  class RepeaterWeek < Repeater #:nodoc:
    WEEK_SECONDS = 604800 # (7 * 24 * 60 * 60)

    def initialize(type)
      super
    end

    def next(pointer)
      super

      if !@current_week_start
        case pointer
        when :future
          day_name_repeater = RepeaterDayName.new(Chronic.start_of_week)
          day_name_repeater.start = @now
          next_week_span = day_name_repeater.next(:future)
          @current_week_start = next_week_span.begin
        when :past
          day_name_repeater = RepeaterDayName.new(Chronic.start_of_week)
          day_name_repeater.start = (@now + RepeaterDay::DAY_SECONDS)
          day_name_repeater.next(:past)
          last_week_span = day_name_repeater.next(:past)
          @current_week_start = last_week_span.begin
        end
      else
        direction = pointer == :future ? 1 : -1
        @current_week_start += direction * WEEK_SECONDS
      end

      Span.new(@current_week_start, @current_week_start + WEEK_SECONDS)
    end

    def this(pointer = :future)
      super

      case pointer
      when :future
        this_week_start = Chronic.time_class.local(@now.year, @now.month, @now.day, @now.hour) + RepeaterHour::HOUR_SECONDS
        day_name_repeater = RepeaterDayName.new(Chronic.start_of_week)
        day_name_repeater.start = @now
        this_week_span = day_name_repeater.this(:future)
        this_week_end = this_week_span.begin
        Span.new(this_week_start, this_week_end)
      when :past
        this_week_end = Chronic.time_class.local(@now.year, @now.month, @now.day, @now.hour)
        day_name_repeater = RepeaterDayName.new(Chronic.start_of_week)
        day_name_repeater.start = @now
        last_week_span = day_name_repeater.next(:past)
        this_week_start = last_week_span.begin
        Span.new(this_week_start, this_week_end)
      when :none
        day_name_repeater = RepeaterDayName.new(Chronic.start_of_week)
        day_name_repeater.start = @now
        last_week_span = day_name_repeater.next(:past)
        this_week_start = last_week_span.begin
        Span.new(this_week_start, this_week_start + WEEK_SECONDS)
      end
    end

    def offset(span, amount, pointer)
      direction = pointer == :future ? 1 : -1
      span + direction * amount * WEEK_SECONDS
    end

    def width
      WEEK_SECONDS
    end

    def to_s
      super << '-week'
    end
  end
end

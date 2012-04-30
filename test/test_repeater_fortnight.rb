require 'helper'

class TestRepeaterFortnight < TestCase

  def setup
    @now = Time.local(2006, 8, 16, 14, 0, 0, 0)
    Chronic.start_of_week = :sunday
  end

  def test_next_future
    fortnights = Chronic::RepeaterFortnight.new(:fortnight)
    fortnights.start = @now

    next_fortnight = fortnights.next(:future)
    assert_equal Time.local(2006, 8, 20), next_fortnight.begin
    assert_equal Time.local(2006, 9, 3), next_fortnight.end

    next_next_fortnight = fortnights.next(:future)
    assert_equal Time.local(2006, 9, 3), next_next_fortnight.begin
    assert_equal Time.local(2006, 9, 17), next_next_fortnight.end
  end

  def test_next_past
    fortnights = Chronic::RepeaterFortnight.new(:fortnight)
    fortnights.start = @now

    last_fortnight = fortnights.next(:past)
    assert_equal Time.local(2006, 7, 30), last_fortnight.begin
    assert_equal Time.local(2006, 8, 13), last_fortnight.end

    last_last_fortnight = fortnights.next(:past)
    assert_equal Time.local(2006, 7, 16), last_last_fortnight.begin
    assert_equal Time.local(2006, 7, 30), last_last_fortnight.end
  end

  def test_this_future
    fortnights = Chronic::RepeaterFortnight.new(:fortnight)
    fortnights.start = @now

    this_fortnight = fortnights.this(:future)
    assert_equal Time.local(2006, 8, 16, 15), this_fortnight.begin
    assert_equal Time.local(2006, 8, 27), this_fortnight.end
  end

  def test_this_past
    fortnights = Chronic::RepeaterFortnight.new(:fortnight)
    fortnights.start = @now

    this_fortnight = fortnights.this(:past)
    assert_equal Time.local(2006, 8, 13, 0), this_fortnight.begin
    assert_equal Time.local(2006, 8, 16, 14), this_fortnight.end
  end

  def test_offset
    span = Chronic::Span.new(@now, @now + 1)

    offset_span = Chronic::RepeaterWeek.new(:week).offset(span, 3, :future)

    assert_equal Time.local(2006, 9, 6, 14), offset_span.begin
    assert_equal Time.local(2006, 9, 6, 14, 0, 1), offset_span.end
  end

  def test_next_future_custom_week_start
    Chronic.start_of_week = :monday
    fortnights = Chronic::RepeaterFortnight.new(:fortnight)
    fortnights.start = @now

    next_fortnight = fortnights.next(:future)
    assert_equal Time.local(2006, 8, 21), next_fortnight.begin
    assert_equal Time.local(2006, 9, 4), next_fortnight.end

    next_next_fortnight = fortnights.next(:future)
    assert_equal Time.local(2006, 9, 4), next_next_fortnight.begin
    assert_equal Time.local(2006, 9, 18), next_next_fortnight.end
  end

  def test_next_past_custom_week_start
    Chronic.start_of_week = :monday
    fortnights = Chronic::RepeaterFortnight.new(:fortnight)
    fortnights.start = @now

    last_fortnight = fortnights.next(:past)
    assert_equal Time.local(2006, 7, 31), last_fortnight.begin
    assert_equal Time.local(2006, 8, 14), last_fortnight.end

    last_last_fortnight = fortnights.next(:past)
    assert_equal Time.local(2006, 7, 17), last_last_fortnight.begin
    assert_equal Time.local(2006, 7, 31), last_last_fortnight.end
  end

  def test_this_future_custom_week_start
    Chronic.start_of_week = :monday
    fortnights = Chronic::RepeaterFortnight.new(:fortnight)
    fortnights.start = @now

    this_fortnight = fortnights.this(:future)
    assert_equal Time.local(2006, 8, 16, 15), this_fortnight.begin
    assert_equal Time.local(2006, 8, 28), this_fortnight.end
  end

  def test_this_past_custom_week_start
    Chronic.start_of_week = :monday
    fortnights = Chronic::RepeaterFortnight.new(:fortnight)
    fortnights.start = @now

    this_fortnight = fortnights.this(:past)
    assert_equal Time.local(2006, 8, 14, 0), this_fortnight.begin
    assert_equal Time.local(2006, 8, 16, 14), this_fortnight.end
  end
end

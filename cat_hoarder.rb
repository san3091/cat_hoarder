require 'gosu'

class HoardTheCats < Gosu::Window
  def initialize
    @window_height = 800
    @window_width = 1100
    super @window_width, @window_height 
    self.caption = 'Collect all the Cats!'
    @image = Gosu::Image.new('cat.png')
    @x = 200
    @y = 200
    @width = 80
    @height = 80
    @velocity_x = 5
    @velocity_y = 5
    @visible = 0 
    @hand = Gosu::Image.new('hand.png')
    @hit = 0
    @font = Gosu::Font.new(30)
    @score = 0
    @playing = true
    @start_time = 0
  end

  def draw
    draw_cat
    draw_hand
    draw_score
    draw_time_left
    announce_hit
    draw_game_over unless @playing
  end

  def update
    if @playing
      move_kitty
      update_time_left
      bounce_off_wall
      blink
      @playing = false if @time_left < 0
    else
    end
  end

  def button_down id
    if @playing 
      collect_kitty if id == Gosu::MsLeft
    else
      play_again if id == Gosu::KbSpace
    end
  end
  
  private

  def bounce_off_wall
    @velocity_x *= -1 if right_edge > @window_width || left_edge < 0
    @velocity_y *= -1 if bottom_edge  > @window_height || top_edge < 0
  end

  def move_kitty
    @x += @velocity_x
    @y += @velocity_y
  end

  def collect_kitty
    if Gosu.distance(mouse_x, mouse_y, @x, @y) < 50 && @visible >= 0 
      @hit = 1
      @visible = 0
      @score += 1
    else
      @hit = -1
    end
  end

  def announce_hit
    case @hit
    when 0
      c = Gosu::Color::NONE
    when 1
      c = Gosu::Color::GREEN
    when -1
      c = Gosu::Color::RED
    end
    draw_quad 0, 0, c, @window_width, 0, c, @window_width, @window_height, c, 0, @window_height, c
    @hit = 0
  end

  def update_time_left
    @time_left = time_left
  end

  def time_left
    100 - ((Gosu.milliseconds() - @start_time) / 1000)
  end

  def blink
    @visible -= 1
    @visible = 60 if @visible < -10 && rand < 0.02
  end

  def draw_cat
    @image.draw left_edge, top_edge, 1 if @visible > 0
  end

  def draw_hand
    @hand.draw mouse_x - 30, mouse_y - 30, 1
  end

  def draw_score
    @font.draw @score.to_s, 700, 20, 2
  end

  def draw_time_left
    @font.draw @time_left.to_s, 20, 20, 2
  end

  def draw_game_over
    @font.draw "Game Over", 300, 300, 3
    @font.draw "press the spacebar to play again", 175, 350, 3
    @visible = 20
  end

  def play_again 
    @playing = true
    @visible = -10
    @start_time = Gosu.milliseconds()
    @score = 0
  end

  def top_edge
    @y - @height / 2
  end

  def left_edge
    @x - @width / 2
  end

  def right_edge
    @x + @width / 2
  end

  def bottom_edge
    @y + @height / 2
  end
end

window = HoardTheCats.new
window.show


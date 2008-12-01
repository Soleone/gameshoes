Shoes.setup do
  source "http://gems.github.com"
  gem 'Soleone-gamefaqs'
end

require 'gamefaqs'
include GameFaqs

Shoes.app do
  background "#e0e0e0"

  flow do
    background "#6564FF"
    image "gamefaqs-logo.gif"
    title "with Shoes", :margin_top => 30
  end

  stack :margin => [40, 40, 10, 40] do
    flow do
      stack :width => '50%' do
        caption "Select a platform:"
        @platform_list = list_box :items => Platform.all, :width => 120, :choose => Platform.find("PC") do |list|
        #@platform_list = list_box :items => [1,2], :width => 120 do |list|
          @platform = list.text
          check_enabled()
        end
      end
      stack :width => '-50%' do
        caption "Enter a game title"
        @game_field = edit_line do
          check_enabled()
        end
      end
    end
    
    flow :margin_top => 20 do
      @average_score_button = button "Average score", :width => 100, :state => "disabled" do
        game = Game.find(@game_field.text, @platform_list.text)
        @average_score.replace("%.2f - #{game.to_s} (#{game.reviews.size} reviews)" % game.average_score)
      end

      @one_line_review_button = button "One line Review", :width => 100, :state => "disabled" do
        review = Random.one_line_review(@game_field.text, @platform_list.text)
        @one_line.replace review
      end

      @review_button = button "Review", :width => 100, :state => "disabled" do
        review = Random.review(@game_field.text, @platform_list.text)
        @full_review.replace review.text
      end
    end
  end
  stack :margin => 20 do
    @average_score = para ""
    @one_line = para ""
    @full_review = para ""
  end
  
  def check_enabled
    [@one_line_review_button, @review_button, @average_score_button].each do |btn|
      if @game_field.text.size > 0 and !@platform_list.text.nil?
        btn.state = nil
      else
        btn.state = "disabled"
      end
    end
  end
end


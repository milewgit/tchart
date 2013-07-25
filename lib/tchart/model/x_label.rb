module TChart
  class XLabel
    
    attr_reader :date
    attr_reader :label
    attr_reader :vertical_grid_line
    
    def initialize(chart, date, x)
      @date = date
      @label = Label.new(xy(x, chart.x_label_y_coordinate), chart.x_label_width, "xlabel", date.year) # TODO: "xlabel" needs to be read
      @vertical_grid_line = GridLine.new(xy(x, 0), xy(x, chart.y_axis_length), "gridline") # TODO: "gridline" needs to be read
    end
    
    def render(tex)
      tex.comment date.year
      label.render(tex)
      vertical_grid_line.render(tex)
    end
    
  end
end

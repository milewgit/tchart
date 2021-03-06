module TChart
  
  #
  # Responsible for calculating chart metrics and storing them
  # in an instance of Layout.  Metrics depend on chart settings
  # and the number and dates ranges of the items being plotted.
  #
  class LayoutBuilder
   
    def self.build(settings, items) # => [ layout, errors ]
      layout = build_layout(settings, items)
      errors = check_layout(layout)
      [ layout, errors ]
    end

  private
  
    def self.build_layout(settings, items) # => Layout
      layout = Layout.new
      layout.x_axis_tick_dates = calc_x_axis_tick_dates( *calc_items_date_range(items) )
      layout.x_axis_length = calc_x_axis_length(settings)
      layout.x_axis_tick_x_coordinates = calc_x_axis_tick_x_coordinates(layout.x_axis_tick_dates, layout.x_axis_length)
      layout.y_axis_length = calc_y_axis_length(settings, items)
      layout.y_axis_label_x_coordinate = calc_y_axis_label_x_coordinate(settings)
      layout.y_axis_tick_y_coordinates = calc_y_axis_tick_y_coordinates(settings, items)
      layout.x_axis_label_y_coordinate = settings.x_axis_label_y_coordinate
      layout.x_axis_label_width = settings.x_axis_label_width
      layout.y_axis_label_width = settings.y_axis_label_width
      layout
    end
    
    def self.check_layout(layout) # => [ String, String, ... ]
      errors = []
      errors << plot_area_too_narrow_error(layout.x_axis_length) if layout.x_axis_length < 1
      errors
    end
    
    def self.plot_area_too_narrow_error(x_axis_length)
      "plot area is too narrow (#{x_axis_length}, min is 1); is chart_width too small, or x_axis_label_width or y_axis_label_width too large?"
    end
  
    def self.calc_items_date_range(items) # [ Date, Date ]
      earliest, latest = nil, nil
      items.each do |item|
        item.date_ranges.each do |date_range|
          earliest = date_range.begin if earliest.nil? or date_range.begin < earliest
          latest = date_range.end if latest.nil? or latest < date_range.end
        end
      end
      current_year = Date.today.year
      earliest ||= Date.new(current_year, 1, 1)
      latest ||= Date.new(current_year, 12, 31)
      [earliest, latest]
    end
  
    def self.calc_x_axis_tick_dates(earliest, latest) # => [ Date, Date, ... ]
      # if ten or fewer years to cover, create a tick every year
      from_year = earliest.year                         # round down to Jan 1st of year
      to_year = latest.year + 1                         # +1 to round up to Jan 1st of the following year
      return make_tick_dates(from_year, to_year, 1) if to_year - from_year <= 10

      # if fifty or fewer years to cover, create a tick every five years
      from_year = (from_year / 5.0).floor * 5           # round down to nearest 1/2 decade
      to_year = (to_year / 5.0).ceil * 5                # round up to nearest 1/2 decade
      return make_tick_dates(from_year, to_year, 5) if to_year - from_year <= 50

      # create a tick every ten years
      from_year = (from_year / 10.0).floor * 10         # round down to nearest decade
      to_year = (to_year / 10.0).ceil * 10              # round up to nearest decade
      return make_tick_dates(from_year, to_year, 10)
    end
    
    def self.make_tick_dates(from_year, to_year, interval) # => [ Date, Date, ... ]
      (from_year..to_year).step(interval).map { |year| Date.new(year,1,1) }
    end
  
    def self.calc_x_axis_tick_x_coordinates(x_axis_tick_dates, x_axis_length) # => [ Numeric, Numeric, ... ]
      num_coords = x_axis_tick_dates.size
      x_interval = x_axis_length / (num_coords - 1.0)
      (0..x_axis_length).step(x_interval).to_a
    end
      
    #
    # 1/2 x_axis_label_width for the left margin, and 1/2 x_axis_label_width for the right margin
    #
    def self.calc_x_axis_length(settings) # => Numeric
      settings.chart_width - settings.y_axis_label_width - settings.x_axis_label_width
    end
    
    #
    # +1 for top and bottom margins, each of which is half the line height
    #
    def self.calc_y_axis_length(settings, items) # => Numeric
      (items.length + 1) * settings.line_height
    end
    
    def self.calc_y_axis_label_x_coordinate(settings) # => Numeric
      0 - ((settings.y_axis_label_width / 2.0) + (settings.x_axis_label_width / 2.0))
    end
    
    def self.calc_y_axis_tick_y_coordinates(settings, items) # => [ Numeric, Numeric, ... ]
      (settings.line_height * items.length).step(settings.line_height, -settings.line_height).to_a
    end
    
  end
end

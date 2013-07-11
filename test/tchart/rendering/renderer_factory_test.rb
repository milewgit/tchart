require_relative '../../test_helper'

module TChart
  describe RendererFactory, "x_label_renderer" do
    it "returns an instance of XLabelRenderer" do
      RendererFactory.x_label_renderer.must_be_instance_of XLabelRenderer
    end
    it "returns the same instance of XLabelRenderer each time it is invoked" do
      RendererFactory.x_label_renderer.must_be_same_as RendererFactory.x_label_renderer
    end
  end
  
  describe RendererFactory, "chart_item_renderer" do
    it "returns an instance of ChartItemRenderer" do
      RendererFactory.chart_item_renderer.must_be_instance_of ChartItemRenderer
    end
    it "returns the same instance of ChartItemRenderer each time it is invoked" do
      RendererFactory.chart_item_renderer.must_be_same_as RendererFactory.chart_item_renderer
    end
  end
  
  describe RendererFactory, "separator_item_renderer" do
    it "returns an instance of SeparatorItemRenderer" do
      RendererFactory.separator_item_renderer.must_be_instance_of SeparatorItemRenderer
    end
    
    it "returns the same instance of SeparatorItemRenderer each time it is invoked" do
      RendererFactory.separator_item_renderer.must_be_same_as RendererFactory.separator_item_renderer
    end
  end
end
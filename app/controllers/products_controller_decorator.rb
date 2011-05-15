ProductsController.class_eval do
  def index
    @searcher = Spree::Config.searcher_class.new(:keywords => "is_active:(true)")
    @products = @searcher.retrieve_products
    @searcher.facets # готовые результаты для отображения фильтра по всем активным товарам
    
    respond_with(@products.first)
  end
end

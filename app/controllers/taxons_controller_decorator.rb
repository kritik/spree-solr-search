TaxonsController.class_eval do
  def show
    @taxon = Taxon.find_by_permalink!(params[:id])
    return unless @taxon

    @searcher = Spree::Config.searcher_class.new(params.merge(:taxon => @taxon.id).merge({:keywords => "is_active:(true)"}))
    @products = @searcher.retrieve_products
    @searcher.facets # готовые результаты для отображения фильтра по всем активным товарам

    respond_with(@taxon)
  end
end

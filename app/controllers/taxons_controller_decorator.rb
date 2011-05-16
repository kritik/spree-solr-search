TaxonsController.class_eval do
  def show
    @taxon = Taxon.find_by_permalink!(params[:id])
    return unless @taxon

    params[:keywords] = "is_active:(true)" if params[:keywords].blank?
    @searcher = Spree::Config.searcher_class.new(params.merge(:taxon => @taxon.id))
    params[:keywords] = "" if params[:keywords].eql?("is_active:(true)")
    @products = @searcher.retrieve_products

    respond_with(@taxon)
  end
end

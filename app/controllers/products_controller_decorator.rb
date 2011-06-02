# ProductsController.class_eval do
#   def index
#     params[:keywords] = "is_active:(true)" if params[:keywords].blank?
#     @searcher = Spree::Config.searcher_class.new(params)
#     params[:keywords] = "" if params[:keywords].eql?("is_active:(true)")
#     @products = @searcher.retrieve_products
#     
#     respond_with(@products)
#   end
# end

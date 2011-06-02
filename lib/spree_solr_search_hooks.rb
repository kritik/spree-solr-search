class SpreeSolrSearchHooks < Spree::ThemeSupport::HookListener
  
  insert_after :search_results, 'products/facets'
  insert_before :search_results, 'products/suggestion'
  
end

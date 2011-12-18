Solr Search
===========

### Installation

1. Add `gem "spree_solr_search", :git => "git://github.com/romul/spree-solr-search.git"` to your Gemfile. Useoriginal one
1. Run `bundle install`
1. Run `rails g spree_solr_search:install`
1. Add `unless params[:keywords].blank?` to your search results result string

**NOTE:** Master branch works only with Spree 0.30.x and above. 
If you want use this extension with Spree 0.10.x or 0.11.x, then you should use spree-0-11-stable branch
    
### Usage

To perform the indexing:

    rake solr:reindex BATCH=500

To start Solr demo-server:

    rake solr:start SOLR_PATH="/home/roman/www/jetty-solr"

To stop Solr demo-server:

    rake solr:stop
    
To configure production Solr server:

    edit RAILS_ROOT/config/solr.yml
    
### Setting up for production

sudo nano /usr/share/solr/conf/schema.xml
put content from https://gist.github.com/1340264


### Dynamic price range
1. nano config/initializers/solr.rb
2. Add here:

```ruby
  max  = Variant.maximum(:price).to_f
  min  = Variant.minimum(:price).to_f
  step = max/6
  ranges = []
  (min..max).step(step){|s| ranges << s }

  I18n.locale = :ru
  PRODUCT_PRICE_RANGES = {}
  ranges.each_with_index{|e,i|  PRODUCT_PRICE_RANGES.merge!({e..(ranges[i+1]) => " #{e.to_i} #{I18n.t(:to, :default => 'до')} #{ranges[i+1].to_i}" }) if ranges[i+1] }
```

### Add dynamic properties
1. nano config/initializers/solr.rb
2. Add here. Don't forget to write me if you can give better code:

```ruby
  translated_properties = Property.all.map{|p| "#{p.name.strip}_property" unless p.presentation.nil? }.compact-PRODUCT_SOLR_FIELDS.map(&:to_s)   
  
  Product.class_eval do
    def my_properties(name)
      pp = ProductProperty.first(:joins => :property,
                   :conditions => {:product_id => self.id, :properties => {:name => name}})
      pp ? pp.value : ''
    end
  end
  
  translated_properties.each do |pp|
    pp_method_name = pp.gsub("-","_")
    method = "def #{pp_method_name}
      my_properties(\"#{pp}\")
    end"
    Product.class_eval do
      eval(method)
    end
    PRODUCT_SOLR_FIELDS << pp_method_name.to_sym
  end
```

### Running rake tasks in background

Read [instructions](https://gist.github.com/890215) how to run rake tasks in background.

P.S. For development recommended use [jetty-solr](http://github.com/dcrec1/jetty-solr) server.



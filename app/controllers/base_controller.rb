class BaseController < ApplicationController
  before_filter :set_model_name_and_klass
  before_filter :ensure_app
  before_filter :ensure_filter, :ensure_sort, only: [:index]

  # The resulting index method looks like this one:
  #   @addresses = Address.all
  #   respond_with @addresses
  #
  def index
    scope = scope(@klass)
    scope = filter(scope)
    scope = sort(scope)
    scope = join(scope)
    scope = paginate(scope)

    instance = instance_variable_set("@#{controller_name}", scope)
    respond(instance)
  end


  # The resulting show method looks like this one:
  #   @customer = Customer.find(params[:id])
  #
  def show
    instance_variable_set("@#{@model_name}", @klass.find(params[:id]))
    respond(instance_variable_get("@#{@model_name}"))
  end


  # The resulting new method looks like this one:
  #   @product = Product.new
  #
  def new
    instance_variable_set("@#{@model_name}", @klass.new)
  end

  # The resulting create method looks like this one:
  #   @customer = Customer.new(customer_params)
  #   flash[:notice] = 'Customer was successfully created.' if @customer.save
  #   respond_with @customer
  #
  def create
    instance = instance_variable_set("@#{@model_name}", @klass.new(create_params))
    flash[:notice] = "#{@model_name.capitalize} was successfully created." if instance.save
    respond(instance)
  end


  # The resulting edit method looks like this one:
  #   @product = Product.find(params[:id])
  #
  def edit
    instance_variable_set("@#{@model_name}", @klass.find(params[:id]))
  end


  # The resulting update method looks like this one:
  #   @address = Address.find(params[:id])
  #   flash[:notice] = 'Address was successfully updated.' if @address.update_attributes(address_params)
  #   respond_with @address
  #
  def update
    instance = instance_variable_set("@#{@model_name}", @klass.find(params[:id]))
    flash[:notice] = "#{@model_name.capitalize} was successfully updated." if instance.update_attributes(update_params)
    respond(instance)
  end


  private

    def set_model_name_and_klass
      @model_name = controller_name.singularize
      @klass = capitalize_(@model_name).constantize
    end

    def capitalize_(name)
      name.split("_").each{ |word| word.capitalize! }.join("")
    end

    def respond(instance)
      if @model_name == "app"
        respond_with instance
      else
        respond_with @app, instance
      end
    end


    # index helper method
    def scope(klass)
      if @model_name == "app"
        klass.all
      else
        klass.where(app_id: @app.id)
      end
    end

    # index helper method
    def filter(scope)
      if @filter.present? && !@filter.blank?

        # special treatment for translation#index --> extract?
        @filter.each do |filter_key, filter_value|
          if filter_key == "value" && !filter_value.blank?
            scope = scope.where("translations.value LIKE ?", "%#{filter_value}%")

          elsif filter_key == "done" && !filter_value.blank?
            scope = scope.where("translations.done = ?", filter_value)

          elsif filter_key == "locale_key" && !filter_value.blank?
            ensure_join :locale
            scope = scope.where("locales.key = ?", filter_value)

          elsif filter_key == "phrase_key" && !filter_value.blank?
            ensure_join :phrase
            scope = scope.where("phrases.key LIKE ?", "%#{filter_value}%")

          elsif filter_key == "phrase_value" && !filter_value.blank?
            ensure_join :phrase
            scope = scope.where("phrases.value LIKE ?", "%#{filter_value}%")
          end
        end

        # return the scope - and not the @filter.each result...
        scope

      else
        scope
      end
    end

    # index helper method
    def sort(scope)
      if @sort.present? && !@sort.blank?

        # special treatment for translation#index --> extract?
        if @sort["locale_key"].present?
          ensure_join :locale
          scope.order("locales.key #{@sort["locale_key"]}")
        elsif @sort["phrase_key"].present?
          ensure_join :phrase
          scope.order("phrases.key #{@sort["phrase_key"]}")
        elsif @sort["phrase_value"].present?
          ensure_join :phrase
          scope.order("phrases.value #{@sort["phrase_value"]}")
        else
          scope.order(@sort)
        end

      else
        scope
      end
    end

    def join(scope)
      if @join.present? && !@join.blank?
        joins = @join.uniq{ |table_name| table_name }.map{ |table_name| table_name.to_sym }

        scope.joins(joins)
      else
        scope
      end
    end

    # index helper method
    def paginate(scope)
      scope.page(params[:page])
    end

    def ensure_join(table_name)
      if @join
        @join << table_name
      else
        @join = [table_name]
      end
    end

    def ensure_sort
      if params[:sort].present?
        @sort = params[:sort]
              # sorting values that are not :symbols lead to errors
        @sort = @sort.inject({}){ |hash, (k,v)| hash[k] = v.to_sym; hash }  if @sort.is_a? Hash
      elsif @default_sort.present?
        @sort = @default_sort
      end

      @sort ||= {}
    end

    def ensure_filter
      if params[:filter].present?
        @filter = params[:filter]
        @filter.delete_if { |k, v| v.empty? }
      end

      @filter ||= {}
    end

    def ensure_app
      return if @model_name == "app"
      @app ||= App.find(params[:app_id])
    end

end

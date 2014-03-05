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

        if @filter[:value].present?
          scope.where("value LIKE ?", "%#{@filter[:value]}%")
        elsif @filter[:key].present?
          scope.where("key LIKE ?", "%#{@filter[:key]}%")
        else
          scope
        end

      else
        scope
      end
    end

    # index helper method
    def sort(scope)
      if @sort.present? && !@sort.blank?
        scope.order(@sort)
      else
        scope
      end
    end

    # index helper method
    def paginate(scope)
      scope.page(params[:page])
    end


    def ensure_sort
      if params[:sort].present?
        @sort = params[:sort]

        # sorting values that are not :symbols lead to errors
        @sort = @sort.inject({}){ |hash, (k,v)| hash[k] = v.to_sym; hash }  if @sort.is_a? Hash
      elsif @default_sort.present?
        @sort = @default_sort
      end
    end

    def ensure_filter
      if params[:filter].present?
        @filter = params[:filter]
      end
    end

    def ensure_app
      return if @model_name == "app"
      @app ||= App.find(params[:app_id])
    end

end

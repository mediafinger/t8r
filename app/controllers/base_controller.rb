class BaseController < ApplicationController
  before_filter :set_model_name_and_klass

  # The resulting index method looks like this one:
  #   @addresses = Address.all
  #   respond_with @addresses
  #
  def index
    instance_variable_set("@#{controller_name}", scope(@klass))
    # respond_with instance_variable_get("@#{controller_name}")
    respond(instance_variable_get("@#{controller_name}"))
  end


  # The resulting show method looks like this one:
  #   @customer = Customer.find(params[:id])
  #
  def show
    instance_variable_set("@#{@model_name}", @klass.find(params[:id]))
    # respond_with instance_variable_get("@#{@model_name}")
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

    def scope(klass)
      if @model_name == "App"
        klass.all
      else
        klass.where(app_id: @app.id)
      end
    end

    def respond(instance)
      if @model_name == "app"
        instance
      else
        respond_with @app, instance
      end
    end
end

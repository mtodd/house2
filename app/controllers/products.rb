class Products < Application
  # provides :xml, :yaml, :js
  
  before :ensure_authenticated, :exclude => [:index, :show]
  
  def index
    @products = Product.all
    display @products
  end

  def show(id = params[:id])
    @product = Product.get(id)
    raise NotFound unless @product
    display @product
  end

  def new
    only_provides :html
    @product = Product.new
    display @product
  end

  def edit(id = params[:id])
    only_provides :html
    @product = Product.get(id)
    raise NotFound unless @product
    display @product
  end

  def create(product = params[:product])
    @product = Product.new(product)
    if @product.save
      redirect resource(@product), :message => {:notice => "Product was successfully created"}
    else
      message[:error] = "Product failed to be created"
      render :new
    end
  end

  def update(id = params[:id], product = params[:product])
    @product = Product.get(id)
    raise NotFound unless @product
    if @product.update_attributes(product)
       redirect resource(@product)
    else
      display @product, :edit
    end
  end

  def destroy(id = params[:id])
    @product = Product.get(id)
    raise NotFound unless @product
    if @product.destroy
      redirect resource(:products)
    else
      raise InternalServerError
    end
  end

end # Products

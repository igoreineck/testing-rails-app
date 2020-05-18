require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  def new_product(title="Test Title", description=nil, price=1, image_url="http://google.com.br")
    Product.new(
      title: title,
      description: description,
      price: price,
      image_url: image_url
    )
  end

  test "product attributes must not be empty" do
    product = Product.new

    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test "product price must be positive" do
    product = new_product("Testing book", nil, 1, "http://google.com.br")

    product.price = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
    product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
    product.errors[:price]

    product.price = 1
    assert product.valid?
  end

  test "image url" do
    ok = %w{ freed.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }

    ok.each do |image_url|
      assert new_product('title', 'desc', 1, image_url).valid?,
        "#{image_url} should not be invalid"
    end

    bad.each do |image_url|
      assert new_product('title', 'desc', 1, image_url).invalid?,
        "#{image_url} should not be valid"
    end
  end

  test "product is not valid without a unique title" do
    product = product_new(products(:ruby).title, "yyy", 1, "fred.gif")
    assert product.invalid?
    assert_equal ["has a already been taken"], product.errors[:title]
  end
end

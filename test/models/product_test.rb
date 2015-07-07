require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  fixtures :products

  def new_product(image_url)
    Product.new(title: "Weiliang's Book",
                description: "helloworld",
                price: 1,
                image_url: image_url) 
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
    product = Product.new(title: "Weiliang's Book",
                         description: "helloworld",
                         image_url: "zzz.jpg")
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

  test "image url " do
    ok = %w{fred.gif fred.jpg fre.png FRE.GIF http://a.b.c/x/y/z/fred.gif}
    bad = %w{fred.doc fred.gif/more fred.gif.more}
    ok.each do |name|
      assert new_product(name).valid?, "#{name} should be valid"
    end
    bad.each do |name|
      assert new_product(name).invalid?, "#{name} should not be valid"
    end
  end

  test "product is not valid without a unique title " do
    product = Product.new(title: products(:ruby).title,
                         description: "yyy",
                         price:1,
                         image_url: "fred.gif")
    assert product.invalid?
    assert_equal ["has already been taken"], product.errors[:title]
    assert_equal [I18n.translate('errors.messages.taken')], product.errors[:title]
  end
end

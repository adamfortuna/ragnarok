require "application_system_test_case"

class ShopsTest < ApplicationSystemTestCase
  setup do
    @shop = shops(:one)
  end

  test "visiting the index" do
    visit shops_url
    assert_selector "h1", text: "Shops"
  end

  test "creating a Shop" do
    visit shops_url
    click_on "New Shop"

    fill_in "Location map", with: @shop.location_map
    fill_in "Location x", with: @shop.location_x
    fill_in "Location y", with: @shop.location_y
    check "Open" if @shop.open
    fill_in "Shop type", with: @shop.shop_type
    fill_in "Start date", with: @shop.start_date
    fill_in "Title", with: @shop.title
    fill_in "Username", with: @shop.username
    click_on "Create Shop"

    assert_text "Shop was successfully created"
    click_on "Back"
  end

  test "updating a Shop" do
    visit shops_url
    click_on "Edit", match: :first

    fill_in "Location map", with: @shop.location_map
    fill_in "Location x", with: @shop.location_x
    fill_in "Location y", with: @shop.location_y
    check "Open" if @shop.open
    fill_in "Shop type", with: @shop.shop_type
    fill_in "Start date", with: @shop.start_date
    fill_in "Title", with: @shop.title
    fill_in "Username", with: @shop.username
    click_on "Update Shop"

    assert_text "Shop was successfully updated"
    click_on "Back"
  end

  test "destroying a Shop" do
    visit shops_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Shop was successfully destroyed"
  end
end

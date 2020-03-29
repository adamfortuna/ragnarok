require "application_system_test_case"

class ItemsTest < ApplicationSystemTestCase
  setup do
    @item = items(:one)
  end

  test "visiting the index" do
    visit items_url
    assert_selector "h1", text: "Items"
  end

  test "creating a Item" do
    visit items_url
    click_on "New Item"

    fill_in "Icon", with: @item.icon
    fill_in "Name", with: @item.name
    fill_in "Npc price", with: @item.npc_price
    fill_in "Slots", with: @item.slots
    fill_in "Subtype", with: @item.subtype
    fill_in "Type", with: @item.type
    fill_in "Uid", with: @item.uid
    fill_in "Unique name", with: @item.unique_name
    click_on "Create Item"

    assert_text "Item was successfully created"
    click_on "Back"
  end

  test "updating a Item" do
    visit items_url
    click_on "Edit", match: :first

    fill_in "Icon", with: @item.icon
    fill_in "Name", with: @item.name
    fill_in "Npc price", with: @item.npc_price
    fill_in "Slots", with: @item.slots
    fill_in "Subtype", with: @item.subtype
    fill_in "Type", with: @item.type
    fill_in "Uid", with: @item.uid
    fill_in "Unique name", with: @item.unique_name
    click_on "Update Item"

    assert_text "Item was successfully updated"
    click_on "Back"
  end

  test "destroying a Item" do
    visit items_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Item was successfully destroyed"
  end
end

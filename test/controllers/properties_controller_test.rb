require 'test_helper'

class PropertiesControllerTest < ActionController::TestCase
  setup do
    @property = properties(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:properties)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create property" do
    assert_difference('Property.count') do
      post :create, property: { bathroom: @property.bathroom, bedroom: @property.bedroom, city: @property.city, description: @property.description, lat: @property.lat, list_id: @property.list_id, lon: @property.lon, photo_url: @property.photo_url, price: @property.price, state: @property.state, status: @property.status, street_address: @property.street_address, tags: @property.tags, url: @property.url }
    end

    assert_redirected_to property_path(assigns(:property))
  end

  test "should show property" do
    get :show, id: @property
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @property
    assert_response :success
  end

  test "should update property" do
    patch :update, id: @property, property: { bathroom: @property.bathroom, bedroom: @property.bedroom, city: @property.city, description: @property.description, lat: @property.lat, list_id: @property.list_id, lon: @property.lon, photo_url: @property.photo_url, price: @property.price, state: @property.state, status: @property.status, street_address: @property.street_address, tags: @property.tags, url: @property.url }
    assert_redirected_to property_path(assigns(:property))
  end

  test "should destroy property" do
    assert_difference('Property.count', -1) do
      delete :destroy, id: @property
    end

    assert_redirected_to properties_path
  end
end

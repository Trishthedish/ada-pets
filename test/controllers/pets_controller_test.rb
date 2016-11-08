require 'test_helper'

class PetsControllerTest < ActionController::TestCase
  # 200 - :ok
  # 204 - :no_content
  # 400 - :bad_request
  # 401 - :unauthorized
  # 403 - :forbidden
  # 404 - :not_found
  # 500 - :internal_server_error

  # Necessary setup to allow ensure we support the API JSON type
  def assert_validation model, fields, message

    refute model.valid?
    fields.each do |field|
      assert (model.errors.include? field.to_sym), "#{field} - #{message}"
      assert (model.errors[field.to_sym].include? message), "#{field} - #{message}"
    end
  end


  setup do
     @request.headers['Accept'] = Mime::JSON
     @request.headers['Content-Type'] = Mime::JSON.to_s
   end

  test "can get #index" do
    get :index
    assert_response :success
  end

  test "#index returns json" do
    get :index
    assert_match 'application/json', response.header['Content-Type']
  end

  test "#index returns an Array of Pet objects" do
    get :index
    # Assign the result of the response from the controller action
    body = JSON.parse(response.body)
    assert_instance_of Array, body
  end

  test "returns three pet objects" do
    get :index
    body = JSON.parse(response.body)
    assert_equal 3, body.length
  end

  test "each pet object contains the relevant keys" do
    keys = %w( age human id name )
    get :index
    body = JSON.parse(response.body)
    assert_equal keys, body.map(&:keys).flatten.uniq.sort
  end

  test "Searching for pet with id 1 will return ' name: 'Peanut', age: 2, human: 'Ada'" do
    get :show, {id: pets(:one).id}

    # why does :succes work and :ok doesnt??
    assert_response :ok

  end


  test "Searching for pet with id [] will return 204 :no_content" do
    get :show, {id: []}

    # why does :succes work and :ok doesnt??
    assert_response :no_content

  end

  test "show page for pet" do
  get :show, id: pets(:one)

  assert_response :ok

  end

  test "show page for pet response with no_content" do
    get :show, id: 5
    assert_response :no_content
  end

  test "10. as_json works and provides the fields required." do
    pet = Pet.new(name: "Kylo", age: 14, human: "Kari")
    pet.save
    fields = %w(name age human id)

    fields.each do |field|
      assert_not_nil pet.as_json()[field]
    end
  end

  test "Test required fields " do
    pet = Pet.new
    assert_validation pet, %w(name human age), "can't be blank"
  end


end

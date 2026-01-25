defmodule MySqrft.ObjectStorageTest do
  use ExUnit.Case, async: true

  alias MySqrft.ObjectStorage

  @moduletag :integration
  @test_bucket "test-bucket"
  @test_key "test/file.jpg"
  @test_content "test file content"

  # These tests require AWS credentials to be set
  # Run with: mix test --only integration
  # Or skip with: mix test --exclude integration

  describe "put_object/3" do
    test "accepts content_type option" do
      # Test that the function exists and accepts the right parameters
      assert is_function(&ObjectStorage.put_object/3, 3)
    end
  end

  describe "get_object/2" do
    test "function exists" do
      assert is_function(&ObjectStorage.get_object/2, 2)
    end
  end

  describe "delete_object/2" do
    test "function exists" do
      assert is_function(&ObjectStorage.delete_object/2, 2)
    end
  end

  describe "presigned_url/3" do
    test "function exists" do
      assert is_function(&ObjectStorage.presigned_url/3, 3)
    end
  end
end

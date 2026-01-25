# Script to verify Tigris Object Storage connectivity
# Run with: mix run priv/repo/verify_tigris.exs

# Ensure credentials are set
access_key = System.get_env("AWS_ACCESS_KEY_ID")
secret_key = System.get_env("AWS_SECRET_ACCESS_KEY")
bucket = Application.get_env(:my_sqrft, :tigris_bucket)

if is_nil(access_key) or is_nil(secret_key) do
  IO.puts("❌ Error: AWS credentials not found in environment variables.")
  IO.puts("Please set AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY.")
  System.halt(1)
end

IO.puts("ℹ️  Verifying Tigris Connectivity...")
IO.puts("Bucket: #{bucket}")

test_key = "tigris_verification_#{:os.system_time(:seconds)}.txt"
test_content = "This is a test file to verify Tigris Object Storage integration."

# 1. Upload
IO.puts("\n[1/3] Uploading test file...")
case MySqrft.ObjectStorage.put_object(test_key, test_content) do
  {:ok, _response} ->
    IO.puts("✅ Upload successful.")

  {:error, reason} ->
    IO.puts("❌ Upload failed: #{inspect(reason)}")
    System.halt(1)
end

# 2. Download
IO.puts("\n[2/3] Downloading test file...")
case MySqrft.ObjectStorage.get_object(test_key) do
  {:ok, %{body: body}} ->
    if body == test_content do
      IO.puts("✅ Download successful and content verified.")
    else
      IO.puts("❌ Download succeeded but content mismatch.")
      IO.puts("Expected: #{test_content}")
      IO.puts("Received: #{body}")
    end

  {:error, reason} ->
    IO.puts("❌ Download failed: #{inspect(reason)}")
end

# 3. Delete
IO.puts("\n[3/3] Deleting test file...")
case MySqrft.ObjectStorage.delete_object(test_key) do
  {:ok, _response} ->
    IO.puts("✅ Deletion successful.")

  {:error, reason} ->
    IO.puts("❌ Deletion failed: #{inspect(reason)}")
end

IO.puts("\n🎉 Tigris Integration Verification Complete!")

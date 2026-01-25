defmodule MySqrft.ObjectStorage do
  @moduledoc """
  Wrapper for interacting with Tigris Object Storage (S3-compatible).
  """

  alias ExAws.S3

  @bucket Application.compile_env(:my_sqrft, :tigris_bucket) || "my-sqrft-bucket"

  @doc """
  Uploads a file to Tigris Object Storage.
  """
  def put_object(key, body, opts \\ []) do
    bucket = Keyword.get(opts, :bucket, @bucket)

    S3.put_object(bucket, key, body, opts)
    |> ExAws.request()
  end

  @doc """
  Downloads a file from Tigris Object Storage.
  """
  def get_object(key, opts \\ []) do
    bucket = Keyword.get(opts, :bucket, @bucket)

    S3.get_object(bucket, key, opts)
    |> ExAws.request()
  end

  @doc """
  Deletes a file from Tigris Object Storage.
  """
  def delete_object(key, opts \\ []) do
    bucket = Keyword.get(opts, :bucket, @bucket)

    S3.delete_object(bucket, key, opts)
    |> ExAws.request()
  end

  @doc """
  Generates a presigned URL for a file.
  """
  def presigned_url(method, key, opts \\ []) do
    bucket = Keyword.get(opts, :bucket, @bucket)
    # Default expires in 1 hour (3600 seconds)
    expires_in = Keyword.get(opts, :expires_in, 3600)

    config = ExAws.Config.new(:s3)

    S3.presigned_url(config, method, bucket, key, expires_in: expires_in)
  end
end

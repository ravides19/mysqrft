defmodule MySqrft.Media.ImageProcessor do
  @moduledoc """
  Handles image processing for uploaded photos.
  Generates multiple sizes (thumbnail, medium, large) from uploaded images.
  """

  require Logger

  @sizes %{
    thumbnail: %{width: 150, height: 150, crop: :center},
    medium: %{width: 800, height: 800, crop: false},
    large: %{width: 1600, height: 1600, crop: false}
  }

  @doc """
  Processes an uploaded photo and generates multiple sizes.

  Returns a map with keys for all generated sizes plus the original.

  ## Parameters
  - `file_path`: Path to the uploaded file
  - `base_key`: Base S3 key (e.g., "profiles/user_id/uuid")

  ## Returns
  `{:ok, %{original: key, thumbnail: key, medium: key, large: key}}`
  or `{:error, reason}`
  """
  def process_photo(file_path, base_key) do
    try do
      # Open the image
      {:ok, image} = Image.open(file_path)

      # Get file extension
      ext = Path.extname(file_path)

      # Process each size
      results = %{
        original: base_key <> ext,
        thumbnail: process_size(image, base_key, ext, :thumbnail),
        medium: process_size(image, base_key, ext, :medium),
        large: process_size(image, base_key, ext, :large)
      }

      {:ok, results}
    rescue
      error ->
        Logger.error("Image processing failed: #{inspect(error)}")
        # Fall back to original for all sizes
        ext = Path.extname(file_path)

        {:error, :processing_failed,
         %{
           original: base_key <> ext,
           thumbnail: base_key <> ext,
           medium: base_key <> ext,
           large: base_key <> ext
         }}
    end
  end

  defp process_size(image, base_key, ext, size_name) do
    size_config = @sizes[size_name]
    key = "#{base_key}_#{size_name}#{ext}"

    try do
      # Generate the resized image
      resized =
        if size_config.crop do
          # Thumbnail: crop to exact size
          Image.thumbnail!(image, "#{size_config.width}x#{size_config.height}",
            crop: size_config.crop
          )
        else
          # Medium/Large: resize to fit within bounds
          Image.thumbnail!(image, "#{size_config.width}x#{size_config.height}")
        end

      # Convert to binary
      {:ok, binary} = Image.write(resized, :memory, suffix: ext)

      # Upload to Tigris
      case MySqrft.ObjectStorage.put_object(key, binary, content_type: get_content_type(ext)) do
        {:ok, _} ->
          key

        {:error, reason} ->
          Logger.error("Failed to upload #{size_name}: #{inspect(reason)}")
          # Return original key as fallback
          base_key <> ext
      end
    rescue
      error ->
        Logger.error("Failed to process #{size_name}: #{inspect(error)}")
        # Return original key as fallback
        base_key <> ext
    end
  end

  defp get_content_type(ext) do
    case String.downcase(ext) do
      ".jpg" -> "image/jpeg"
      ".jpeg" -> "image/jpeg"
      ".png" -> "image/png"
      ".webp" -> "image/webp"
      _ -> "application/octet-stream"
    end
  end
end

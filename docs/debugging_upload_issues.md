# Debugging LiveView Upload Connection Issues

## Problem
You're seeing "Failed to push file progress Error: no connection" when trying to upload photos.

## Root Cause
This error occurs when the LiveView tries to upload a file before the WebSocket connection is fully established, or when the connection drops during upload.

## Fixes Applied

### 1. Removed `auto_upload` Configuration
The `auto_upload: true` option was causing uploads to start immediately, potentially before the WebSocket connection was ready. I've removed this to ensure uploads only happen when you click the "Upload Photo" button.

### 2. Simplified Upload Flow
The upload now follows a clear manual flow:
1. User selects file
2. File preview shows
3. User clicks "Upload Photo" button
4. Upload starts only after button click

## How to Test

### Step 1: Check WebSocket Connection
1. Open your browser's Developer Tools (F12 or Cmd+Option+I)
2. Go to the Console tab
3. Navigate to `http://localhost:4000/photos`
4. You should see WebSocket connection messages like:
   ```
   [Phoenix] Joined channel successfully
   ```

### Step 2: Test File Upload
1. Click "Click to upload" or drag a photo
2. Wait for the preview to appear
3. Click the "Upload Photo" button
4. Watch the Console for any errors

### Step 3: Verify Tigris Credentials
If upload fails with Tigris errors, verify your environment variables:
```bash
echo $AWS_ACCESS_KEY_ID
echo $AWS_SECRET_ACCESS_KEY
echo $AWS_BUCKET_NAME
```

## Common Issues & Solutions

### Issue: "no connection" error
**Solution**: Refresh the page and wait 2-3 seconds before attempting upload. The WebSocket needs time to establish.

### Issue: Upload starts but fails
**Solution**: Check browser console for Tigris-specific errors. Verify credentials are set correctly.

### Issue: Photo doesn't appear after upload
**Solution**: Check if the Tigris URL is accessible. The URL format should be:
```
https://{bucket}.fly.storage.tigris.dev/profiles/{user_id}/{uuid}.{ext}
```

## Debug Commands

### Check if server is running:
```bash
lsof -i :4000
```

### View server logs:
The Phoenix server terminal will show upload attempts and any Tigris errors.

### Test Tigris connectivity:
```bash
mix run priv/repo/verify_tigris.exs
```

## Next Steps
If you're still experiencing issues:
1. Share the exact error message from browser console
2. Share any server logs from the Phoenix terminal
3. Verify your Tigris bucket is accessible and credentials are correct

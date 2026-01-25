# Fixing Tigris 403 Access Denied Error

## The Problem
You're getting a 403 Access Denied error from Tigris when trying to upload files:

```
<Error>
  <Code>AccessDenied</Code>
  <Message>Access Denied.</Message>
  <Resource>/mysqrft-local-dev/profiles/...</Resource>
  <BucketName>mysqrft-local-dev</BucketName>
</Error>
```

This means your AWS credentials don't have write permissions to the bucket `mysqrft-local-dev`.

## Solutions

### Option 1: Verify Your Credentials Have Write Access

1. **Check your Tigris dashboard** to ensure the access key you're using has write permissions
2. **Verify the bucket name** is correct: `mysqrft-local-dev`
3. **Check the bucket policy** allows PutObject operations

### Option 2: Create a New Access Key with Proper Permissions

In your Tigris dashboard:

1. Go to **Access Keys** section
2. Create a new access key with **Read/Write** permissions
3. Update your environment variables:

```bash
export AWS_ACCESS_KEY_ID="your_new_access_key"
export AWS_SECRET_ACCESS_KEY="your_new_secret_key"
export AWS_BUCKET_NAME="mysqrft-local-dev"
```

4. Restart your Phoenix server:
```bash
# Stop the current server (Ctrl+C)
mix phx.server
```

### Option 3: Use a Different Bucket

If you don't have permissions for `mysqrft-local-dev`, create a new bucket or use an existing one:

1. Create a new bucket in Tigris (e.g., `mysqrft-dev-photos`)
2. Update your environment variable:
```bash
export AWS_BUCKET_NAME="mysqrft-dev-photos"
```
3. Restart the server

### Option 4: Check Bucket Policy (Advanced)

Your bucket needs a policy that allows PutObject. Example policy:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::YOUR_ACCOUNT:user/YOUR_USER"
      },
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Resource": "arn:aws:s3:::mysqrft-local-dev/*"
    }
  ]
}
```

## Verify the Fix

After updating credentials, test with:

```bash
mix run priv/repo/verify_tigris.exs
```

This should show:
```
✅ Upload successful.
✅ Download successful and content verified.
✅ Deletion successful.
```

## Common Issues

### Issue: Credentials are correct but still getting 403
**Solution**: The bucket might have additional restrictions. Check:
- Bucket is in the correct region
- No IP restrictions on the bucket
- Access key is not expired

### Issue: Works in verify script but not in LiveView
**Solution**: The Phoenix server might not have picked up the new environment variables. Make sure to:
1. Set env vars in the same terminal session
2. Restart the server completely (not just reload)

## Testing the Upload

Once credentials are fixed:

1. Navigate to `http://localhost:4000/photos`
2. Upload a photo
3. You should see "Photo uploaded successfully"
4. The photo should appear in the gallery
5. Check the browser console - no errors should appear

## Need Help?

If you're still getting 403 errors after trying these solutions, check:
1. The exact error message in the Phoenix server logs
2. Your Tigris dashboard for any alerts or permission issues
3. Whether the bucket exists and you have access to it
